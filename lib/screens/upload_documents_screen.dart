import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/upload_raw.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:path/path.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UploadDocumentsScreen extends StatelessWidget {
  static const String id = "/UploadDocumentsScreen";

  UploadDocumentsScreen({super.key});

  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    // Expect these from arguments
    final args = Get.arguments ?? {};
    final String csID = (args['cs_id'] ?? '').toString();
    final String requestID = (args['request_id'] ?? '').toString();
    final String categoryID = (args['category_id'] ?? '').toString();
    final String title = (args['title'] ?? '').toString();
    double width = MediaQuery.of(context).size.width;
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          automaticallyImplyLeading: true,
          onTap: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: controller.showSpinner.value
              ? controller.config.loadingView()
              : CommonSafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          title.toUpperCase(),
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Buttons row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextIconButton(
                              title: "Select Files",
                              icon: "assets/icons/attachment.png",
                              onTap: controller.pickUploadFiles,
                              width: width,
                              height: 46,
                              color: primaryColor,
                              borderRadius: 50,
                              borderColor: primaryColor,
                              iconColor: Colors.white,
                              iconSize: 15,
                              textStyle: titleTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              orientation: "left",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextIconButton(
                              title: "Clear All",
                              icon: "assets/icons/close.png",
                              onTap: controller.clearUploadFiles,
                              width: width,
                              height: 46,
                              color: primaryColor,
                              borderRadius: 50,
                              borderColor: primaryColor,
                              iconColor: Colors.white,
                              iconSize: 15,
                              textStyle: titleTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Selected files list
                      Expanded(
                        child:
                            controller.uploadFiles.isEmpty
                                ? const Center(child: Text("No files selected"))
                                : ListView.builder(
                                  itemCount: controller.uploadFiles.length,
                                  itemBuilder: (context, index) {
                                    final File file =
                                        controller.uploadFiles[index];
                                    final name = p.basename(file.path);
                                    final ext =
                                        p
                                            .extension(file.path)
                                            .replaceFirst('.', '')
                                            .toLowerCase();

                                    IconData icon = FontAwesomeIcons.file;
                                    if (['jpg', 'jpeg', 'png'].contains(ext)) {
                                      icon = FontAwesomeIcons.fileImage;
                                    }
                                    if (ext == 'pdf') {
                                      icon = FontAwesomeIcons.filePdf;
                                    }
                                    if (['doc', 'docx'].contains(ext)) {
                                      icon = FontAwesomeIcons.fileWord;
                                    }
                                    if (['xls', 'xlsx', 'csv'].contains(ext)) {
                                      icon = FontAwesomeIcons.fileExcel;
                                    }
                                    if (['ppt', 'pptx'].contains(ext)) {
                                      icon = FontAwesomeIcons.filePowerpoint;
                                    }

                                    return UploadRaw(
                                      iconData: icon,
                                      file: file,
                                      name: name,
                                      onTap:
                                          () => controller.removeUploadFileAt(
                                            index,
                                          ),
                                    );
                                  },
                                ),
                      ),

                      const SizedBox(height: 12),

                      // Upload button
                      CustomTextButton(
                        width: width,
                        title: "Upload",
                        height: 46,
                        color: primaryColor,
                        borderRadius: 50,
                        borderColor: primaryColor,
                        textStyle: titleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onTap: () {
                          controller.submitUploadDocuments(
                            csID,
                            requestID,
                            categoryID,
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
