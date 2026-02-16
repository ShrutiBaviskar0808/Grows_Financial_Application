import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DashboardController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  var showSpinner = false.obs,
      userData = {}.obs,
      businessData = {}.obs,
      title = "".obs,
      type = "".obs,
      clientID = "".obs,
      businessID = "".obs,
      services = [].obs,
      businessType = [].obs,
      selectedBusinessType = "".obs,
      businessNameError = "".obs,
      businessNumberError = "".obs;

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessNumberController =
      TextEditingController();
  List<DropdownMenuItem<String>> businessTypeMenuItems = [];
  final Map<String, IconData> mdiIconMap = {
    "mdi-account-outline": MdiIcons.accountOutline,
    "mdi-dolly": MdiIcons.dolly,
    "mdi-cash": MdiIcons.cash,
    "mdi-notebook-edit-outline": MdiIcons.notebookEditOutline,
    "mdi-book-information-variant": MdiIcons.bookInformationVariant,
    "mdi-office-building-marker-outline": MdiIcons.officeBuildingMarkerOutline,
    "mdi-credit-card-check-outline": MdiIcons.creditCardCheckOutline,
    "mdi-cash-check": MdiIcons.cashCheck,
    // Add more as needed!
  };

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // final arguments = Get.arguments as Map;
    getBusinessType();
    getUser();
    getServices("Personal");
  }

  void getServices(String type) async {
    showSpinner(true);
    try {
      this.type.value = type;
      var response = await restApi.getServices(type);
      if (response != null && response['result'] == 'success') {
        services.value = response['data'];
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
      businessID.value = await config.getStringSharedPreferences("businessID");
      clientID.value = await config.getStringSharedPreferences("id");
      if (businessID.value.isNotEmpty) {
        var response = await restApi.getBusiness(businessID.value);

        if (response != null && response['result'] == 'success') {
          businessData.value = response['data'];
          title.value = response['data']['corporation_business_name'];
        }
      }
      var response = await restApi.getUser(clientID.value);

      if (response != null && response['result'] == 'success') {
        userData.value = response['data'];
        if (businessID.isEmpty) {
          title.value = response['data']['name'];
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  // Add New Business

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

  void handleDropdownChange({
    required String? value,
    required RxString target,
  }) {
    target.value = value ?? '';
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
}
