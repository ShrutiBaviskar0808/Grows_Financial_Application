import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class AccountController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessNumberController =
      TextEditingController();
  var showSpinner = false.obs,
      userData = {}.obs,
      request = 0.obs,
      clientID = "".obs,
      accounts = [].obs,
      requests = [].obs,
      businessType = [].obs,
      selectedBusinessType = "".obs,
      businessNameError = "".obs,
      businessNumberError = "".obs;
  List<DropdownMenuItem<String>> businessTypeMenuItems = [];
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;

  final uploadFiles = <File>[].obs;
  final uploadFileNames = <String>[].obs;
  final RxBool showUploadFiles = false.obs;
  final BackdropNavController nav = Get.put(BackdropNavController());

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  void loadData() {
    getBusinessType();
    getUser();
    getAccount();
    getDocumentRequest();
  }

  void nameSubmit(text) {
    businessNameError.value = "";
    update();
  }

  void bnSubmit(String value) {
    // regex: exactly 9 digits
    final isValid = RegExp(r'^\d{9}$').hasMatch(value);
    if (!isValid) {
      businessNumberError.value = 'Please enter 9 digits Business Number';
    } else {
      businessNumberError.value = '';
    }
    update();
  }

  void getBusinessType() async {
    try {
      showSpinner(true);
      var response = await restApi.getBusinessType();

      if (response != null && response['result'] == 'success') {
        businessType.value = response['data'];
        businessTypeMenuItems = config.buildDropDownMenuItems(businessType);
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  void getUser() async {
    showSpinner(true);
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getUser(clientID.value);

        if (response != null && response['result'] == 'success') {
          userData.value = response['data'];
        } else {
          config.showToastFailure(response['msg']);
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    }
    update();
  }

  void getAccount() async {
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getAccounts(clientID.value);

        if (response != null && response['result'] == 'success') {
          accounts.value = response['data'];
        } else {
          config.showToastFailure(response['msg']);
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    }

    update();
  }

  void getDocumentRequest() async {
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getDocumentRequest(clientID.value);

        if (response != null && response['result'] == 'success') {
          requests.value = response['data'];
        } else {
          requests.value = [];
          // config.showToastFailure(response['msg']);
        }
        request.value = requests.length;
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }

    update();
  }

  void selectImage(ImageSource source, BuildContext context) async {
    final picture = await imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );

    imageFile = picture;
    if (context.mounted) {
      if (imageFile != null) {
        uploadPhoto(imageFile!.path, context);
      }
    }
  }

  void uploadPhoto(String imagePath, BuildContext context) async {
    try {
      log("Upload Photo");
      showSpinner(true);
      clientID.value = await config.getStringSharedPreferences("id");
      var response = await restApi.uploadProfilePhoto(
        clientID.value,
        imagePath,
      );

      if (response != null) {
        if (response['result'] == "success") {
          config.showToastSuccess("Profile photo updated successfully");

          final BackdropNavController nav = Get.find<BackdropNavController>();
          nav.getUser();
          // ✅ Refresh account list (which refreshes UI)
          getAccount();
          getUser();
        }
      }
      showSpinner(false);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error :: $e");
      }

      showSpinner(false);
    }
  }

  void addAccount() async {
    try {
      Get.back();
      showSpinner(true);
      clientID.value = await config.getStringSharedPreferences("id");
      var response = await restApi.addAccount(
        clientID.value,
        selectedBusinessType.value,
        businessNameController.text,
        businessNumberController.text,
      );

      if (response != null && response['result'] == 'success') {
        getAccount();
        config.showToastSuccess(response['msg']);
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  Widget dialogNewBusinessForm(double width) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              "Add Business Profile".toUpperCase(),
              style: titleTextStyle.copyWith(
                fontSize: 20,
                fontWeight: boldFont,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: grey2,
            hintText: "Business Name",
            textController: businessNameController,
            errorText: businessNameError.value,
            errorColor: Colors.red,
            onSubmitted: nameSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 50.0,
            keyBoardType: TextInputType.name,
            leadingIcon: Icon(
              FontAwesomeIcons.building,
              color: grey2,
              size: 18,
            ),
          ),
          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: grey2,
            hintText: "Business Number",
            textController: businessNumberController,
            errorText: businessNumberError.value,
            errorColor: Colors.red,
            onSubmitted: bnSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 50.0,
            keyBoardType: TextInputType.number,
            leadingIcon: Icon(FontAwesomeIcons.info, color: grey2, size: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: primaryColor),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select Business Type'),
                  value:
                      selectedBusinessType.value.isEmpty
                          ? null
                          : selectedBusinessType.value,
                  items: businessTypeMenuItems,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                  onChanged:
                      (value) => handleDropdownChange(
                        value: value,
                        target: selectedBusinessType,
                      ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextButton(
                    title: "Add",
                    onTap: addAccount,
                    height: 40,
                    width: width,
                    color: primaryColor,
                    borderRadius: 50.0,
                    textStyle: titleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: CustomTextButton(
                    title: "Cancel",
                    onTap: () {
                      Get.back();
                    },
                    height: 40,
                    width: width,
                    color: primaryColor,
                    borderRadius: 50.0,
                    textStyle: titleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Multi File Upload Form

  void clearUploadFiles() {
    uploadFiles.clear();
    uploadFileNames.clear();
    showUploadFiles(false);
    update();
  }

  void removeUploadFileAt(int index) {
    if (index >= 0 && index < uploadFiles.length) {
      uploadFiles.removeAt(index);
      uploadFileNames.removeAt(index);
      showUploadFiles(uploadFiles.isNotEmpty);
      update();
    }
  }

  Future<void> pickUploadFiles() async {
    try {
      FilePickerResult? result;

      if (Platform.isAndroid) {
        // ✅ Avoid DocumentsUI crash (mimeTypes null) by using FileType.any
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );
      } else {
        // iOS: safe to use custom
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        );
      }

      if (result == null || result.files.isEmpty) return;

      final allowed = {'jpg', 'jpeg', 'png', 'pdf'};
      final newFiles = <File>[];
      final newNames = <String>[];

      for (final path in result.paths.whereType<String>()) {
        final ext = p.extension(path).replaceFirst('.', '').toLowerCase();

        // ✅ filter manually (Android case)
        if (!allowed.contains(ext)) continue;

        // ✅ avoid duplicates
        if (uploadFiles.any((f) => f.path == path)) continue;

        newFiles.add(File(path));
        newNames.add(p.basename(path));
      }

      if (newFiles.isEmpty) {
        config.showToastFailure("Only JPG/PNG/PDF allowed");
        return;
      }

      uploadFiles.addAll(newFiles);
      uploadFileNames.addAll(newNames);

      update();
    } catch (e) {
      config.debugLog("pickUploadFiles error: $e");
      config.showToastFailure("Failed to pick files");
    }
  }

  void submitUploadDocuments(
    String csID,
    String requestID,
    String categoryID,
  ) async {
    try {
      if (uploadFiles.isEmpty) {
        config.showToastFailure("Please select files");
        return;
      }

      showSpinner(true);

      clientID.value = await config.getStringSharedPreferences("id");

      // Convert to path list like your old code
      final List<String> paths = uploadFiles.map((e) => e.path).toList();

      final res = await restApi.uploadDocuments(
        csID,
        requestID,
        categoryID,
        paths,
      );

      if (res != null && res['result'] == 'success') {
        config.showToastSuccess(res['msg'] ?? "Documents uploaded");
        clearUploadFiles();

        // refresh if needed
        Get.offNamedUntil(HomeScreen.id, ModalRoute.withName(HomeScreen.id));
        nav.openPage(AccountsScreen.id);
      } else {
        config.showToastFailure(res?['msg'] ?? "Upload failed");
      }
    } catch (e) {
      config.debugLog("submitUploadDocuments error: $e");
      config.showToastFailure("Upload failed");
    } finally {
      showSpinner(false);
      update();
    }
  }

  void handleDropdownChange({
    required String? value,
    required RxString target,
  }) {
    target.value = value ?? '';
    update();
  }
}
