import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/components/form_raw.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormT2Step1Screen extends StatelessWidget {
  static const String id = "/FormT2Step1Screen";
  final FormController controller = Get.find();

  FormT2Step1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: controller.showSpinner.value
              ? controller.config.loadingView()
              : CommonSafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Corporation Tax File - Step 1",
                            style: titleTextStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText: "Corporation Legal Name (Required)",
                              textController:
                                  controller.corporationNameController,
                              hintColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              focusNode: controller.corporationNameNode,
                              errorText: controller.corporationNameError.value,
                              onChanged: (text) {
                                controller.corporationNameError.value = "";
                                controller.update();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "Mentioned in the certificate of incorporation",
                                style: subTitleTextStyle.copyWith(fontSize: 12),
                              ),
                            ),
                            CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText: "Corporation Number",
                              textController:
                                  controller.corporationNumberController,
                              hintColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              focusNode: controller.corporationNumberNode,
                              errorText:
                                  controller.corporationNumberError.value,
                              onChanged: (text) {
                                controller.corporationNumberError.value = "";
                                controller.update();
                              },
                            ),
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question: "Corporation Type (Required)",
                              questionStyle: titleTextStyle,
                              choices: controller.corporationTypeOptions,
                              selectedValue: controller.selectedCorporationType,
                              onChanged:
                                  (state) =>
                                      controller.handleS2MultiChange<String>(
                                        selected: state,
                                        selectedValuesTarget:
                                            controller.selectedCorporationType,
                                        errorText:
                                            controller.corporationTypeError,
                                      ),
                              focusNode: controller.corporationTypeNode,
                              errorText: controller.corporationTypeError.value,
                            ),
                            FormAddressRaw(
                              title: 'Business Address (Required)',
                              address1Controller:
                                  controller.businessAddress1Controller,
                              address2Controller:
                                  controller.businessAddress2Controller,
                              cityController: controller.businessCityController,
                              postalCodeController:
                                  controller.businessPostalCodeController,
                              list: controller.statesOptions,
                              selectedValue: controller.businessState.value,
                              onChanged:
                                  (
                                    state,
                                  ) => controller.handleS2SingleChange<String>(
                                    selected: state,
                                    errorText: controller.businessStateError,
                                    resultTextTarget: controller.businessState,
                                  ),
                              address1Node: controller.businessAddress1Node,
                              address2Node: controller.businessAddress2Node,
                              cityNode: controller.businessCityNode,
                              stateNode: controller.businessStateNode,
                              postalCodeNode: controller.businessPostalCodeNode,
                              address1Error:
                                  controller.businessAddress1Error.value,
                              address2Error:
                                  controller.businessAddress2Error.value,
                              cityError: controller.businessCityError.value,
                              stateError: controller.businessStateError.value,
                              postalCodeError:
                                  controller.businessPostalCodeError.value,
                            ),
                            CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText: "Incorporation Date (Required)",
                              textController:
                                  controller.incorporationDateController,
                              hintColor: primaryColor,
                              maxLines: 1,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              onTap:
                                  () => controller.handleDatePick(
                                    context: context,
                                    currentDate: controller.currentDate,
                                    controller:
                                        controller.incorporationDateController,
                                    value: controller.incorporationDate,
                                    errorText:
                                        controller.incorporationDateError,
                                  ),
                              readOnly: true,
                              focusNode: controller.incorporationDateNode,
                              errorText:
                                  controller.incorporationDateError.value,
                              onChanged: (text) {
                                controller.incorporationDateError.value = "";
                                controller.update();
                              },
                            ),
                            CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText: "9 Digit Business Number",
                              textController:
                                  controller.businessNumberController,
                              hintColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              focusNode: controller.businessNumberNode,
                              errorText: controller.businessNumberError.value,
                              onChanged: (text) {
                                controller.businessNumberError.value = "";
                                controller.update();
                              },
                            ),
                            CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText: "Nature of Business Activity",
                              textController:
                                  controller.businessActivityController,
                              hintColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              focusNode: controller.businessActivityNode,
                              errorText: controller.businessActivityError.value,
                              onChanged: (text) {
                                controller.businessActivityError.value = "";
                                controller.update();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "Summary of business operations and objectives.",
                                style: subTitleTextStyle.copyWith(fontSize: 12),
                              ),
                            ),
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question:
                                  "Tax file that you want for this Corporation",
                              questionStyle: titleTextStyle,
                              choices: controller.taxFileOptions,
                              selectedValue: controller.selectedTaxFile,
                              onChanged:
                                  (state) =>
                                      controller.handleS2MultiChange<String>(
                                        selected: state,
                                        selectedValuesTarget:
                                            controller.selectedTaxFile,
                                        errorText: controller.taxFileError,
                                      ),
                              focusNode: controller.taxFileNode,
                              errorText: controller.taxFileError.value,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "Personal Tax Information",
                                style: titleTextStyle.copyWith(fontSize: 24),
                              ),
                            ),
                            SizedBox(height: 15),
                            FormDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question:
                                  "Would you like to file your tax return for 2023 or earlier? (Required)",
                              questionStyle: titleTextStyle,
                              choices: controller.yesNoOptions,
                              selectedValue: controller.fileForEarlier.value,
                              onChanged:
                                  (
                                    state,
                                  ) => controller.handleS2SingleChange<String>(
                                    selected: state,
                                    resultTextTarget: controller.fileForEarlier,
                                    errorText: controller.fileForEarlierError,
                                  ),
                              focusNode: controller.fileForEarlierNode,
                              errorText: controller.fileForEarlierError.value,
                            ),
                            Obx(() => Visibility(
                                visible: controller.fileForEarlier.value == "Yes",
                                child: FormMultiDropDown<String>(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 0.0,
                                  ),
                                  question:
                                      "Please select the years for which you would like to file taxes. (Required)",
                                  questionStyle: titleTextStyle,
                                  choices: controller.taxYearsOptions,
                                  selectedValue: controller.selectedYears,
                                  onChanged:
                                      (state) =>
                                          controller.handleS2MultiChange<String>(
                                            selected: state,
                                            selectedValuesTarget:
                                                controller.selectedYears,
                                            errorText: controller.taxYearsError,
                                          ),
                                  focusNode: controller.taxYearsNode,
                                  errorText: controller.taxYearsError.value,
                                ),
                              ),
                            ),

                            CustomTextButton(
                              title: "Next",
                              onTap: controller.submitStep1,
                              width: width,
                              height: 56,
                              color: primaryColor,
                              borderRadius: 15.0,
                              textStyle: titleTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
  }
}
