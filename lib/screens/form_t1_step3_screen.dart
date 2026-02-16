import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormT1Step3Screen extends StatelessWidget {
  static const String id = "/FormT1Step3Screen";

  FormT1Step3Screen({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child:
              controller.showSpinner.value
                  ? controller.config.loadingView()
                  : CommonSafeArea(
                    child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Personal Tax File - Step 3",
                            style: titleTextStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        SizedBox(height: 15),
                        //Form Fields
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Focus(
                                focusNode: controller.acknowledgmentNode,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Consent for Pricing Acknowledgment (Required)",
                                      style: subTitleTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: semiBoldFont,
                                        color:
                                            controller
                                                    .acknowledgmentError
                                                    .isNotEmpty
                                                ? Colors.red
                                                : Colors.black,
                                      ),
                                    ),
                                    CheckboxListTile(
                                      title: Text(
                                        controller.acknowledgment[0]['text'],
                                      ),
                                      value: controller.selectedAcknowledgment
                                          .contains(
                                            controller
                                                .acknowledgment[0]['value'],
                                          ),
                                      onChanged:
                                          (
                                            checked,
                                          ) => controller.handleCheckBoxChange(
                                            checked: checked,
                                            value:
                                                controller
                                                    .acknowledgment[0]['value'],
                                            list:
                                                controller
                                                    .selectedAcknowledgment,
                                            errorText:
                                                controller.acknowledgmentError,
                                          ),
                                    ),
                                    const SizedBox(height: 5),
                                    Visibility(
                                      visible:
                                          controller
                                              .acknowledgmentError
                                              .isNotEmpty,
                                      child: Text(
                                        controller.acknowledgmentError.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(controller.infoText.value),
                              ),
                            ),
                            CustomTextButton(
                              title: "Next",
                              onTap: controller.submitStep3,
                              width: width,
                              height: 56,
                              color: primaryColor,
                              borderRadius: 10.0,
                              textStyle: titleTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
        ),
      ),
    );
  }
}
