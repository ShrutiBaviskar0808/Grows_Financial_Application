import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/components/form_raw.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class FormT2Step2Screen extends StatelessWidget {
  static const String id = "/FormT2Step2Screen";
  final FormController controller = Get.find();

  FormT2Step2Screen({super.key});

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
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Corporation Tax File - Step 2",
                            style: titleTextStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Basic Information
                                  FormBasicInfoRaw(
                                    title: "Name As Per SIN Letter (Required)",
                                    firstNameController:
                                        controller.firstNameController,
                                    middleNameController:
                                        controller.middleNameController,
                                    lastNameController:
                                        controller.lastNameController,
                                    dobController: controller.dobController,
                                    onTap:
                                        () => controller.handleDatePick(
                                          context: context,
                                          currentDate: controller.currentDate,
                                          controller: controller.dobController,
                                          value: controller.dob,
                                        ),
                                    firstNameError:
                                        controller.firstNameError.value,
                                    middleNameError:
                                        controller.middleNameError.value,
                                    lastNameError:
                                        controller.lastNameError.value,
                                    dobError: controller.dobError.value,
                                    firstNameNode: controller.firstNameNode,
                                    middleNameNode: controller.middleNameNode,
                                    lastNameNode: controller.lastNameNode,
                                    dobNode: controller.dobNode,
                                    firstNameOnChanged: (text) {
                                      controller.firstNameError.value = "";
                                      controller.update();
                                    },
                                    middleNameOnChanged: (text) {
                                      controller.middleNameError.value = "";
                                      controller.update();
                                    },
                                    lastNameOnChanged: (text) {
                                      controller.lastNameError.value = "";
                                      controller.update();
                                    },
                                  ),
                                  //Current Address
                                  FormAddressRaw(
                                    title: 'Full Current Address',
                                    address1Controller:
                                        controller.currentAddress1Controller,
                                    address2Controller:
                                        controller.currentAddress2Controller,
                                    cityController:
                                        controller.currentCityController,
                                    postalCodeController:
                                        controller.currentPostalCodeController,
                                    list: controller.statesOptions,
                                    selectedValue:
                                        controller.currentState.value,
                                    onChanged:
                                        (state) => controller
                                            .handleS2SingleChange<String>(
                                              selected: state,

                                              resultTextTarget:
                                                  controller.currentState,
                                              errorText:
                                                  controller.currentStateError,
                                            ),
                                    address1Node:
                                        controller.currentAddress1Node,
                                    address2Node:
                                        controller.currentAddress2Node,
                                    cityNode: controller.currentCityNode,
                                    stateNode: controller.currentStateNode,
                                    postalCodeNode:
                                        controller.currentPostalCodeNode,
                                    address1Error:
                                        controller.currentAddress1Error.value,
                                    address2Error:
                                        controller.currentAddress2Error.value,
                                    cityError:
                                        controller.currentCityError.value,
                                    stateError:
                                        controller.currentStateError.value,
                                    postalCodeError:
                                        controller.currentPostalCodeError.value,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0,
                                      vertical: 8.0,
                                    ),
                                    child: IntlPhoneField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 15.0,
                                        ),
                                        alignLabelWithHint: false,
                                        hintText: "Phone",
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorText:
                                        controller
                                            .phoneError
                                            .value
                                            .isNotEmpty
                                            ? controller.phoneError.value
                                            : null,
                                        hintStyle: TextStyle(
                                          color: primaryColor,
                                          fontSize: 18,
                                        ),
                                        // labelText: hintText,
                                        labelStyle: TextStyle(
                                          color: grey2.withValues(alpha: 0.4),
                                          fontSize: 18,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: grey2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color:
                                            controller
                                                .phoneError
                                                .value
                                                .isEmpty
                                                ? Colors.transparent
                                                : Colors.red,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color:
                                            controller
                                                .phoneError
                                                .value
                                                .isEmpty
                                                ? Colors.transparent
                                                : Colors.red,
                                          ),
                                        ),
                                        counterText: "",
                                      ),
                                      onSubmitted: controller.phoneSubmit,
                                      controller: controller.phoneController,
                                      countries:
                                      countries
                                          .where((c) => c.code == 'CA')
                                          .toList(),
                                      showDropdownIcon: false,
                                      initialCountryCode: "CA",
                                      showCountryFlag: false,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: grey2,
                                        fontSize: 18,
                                      ),
                                      dropdownTextStyle: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                      ),
                                      dropdownIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: primaryColor,
                                      ),
                                      onChanged: (phone) {
                                        controller.phoneController.text =
                                            phone.number;
                                        controller.phone.value =
                                            phone.completeNumber;
                                        controller.phoneSubmit(phone.number);
                                      },
                                      onCountryChanged: (country) {
                                        controller.countryCode.value =
                                        "+${country.dialCode}";
                                        controller.update();
                                      },
                                      showCursor: true,
                                    ),
                                  ),
                                  CustomTextField(
                                    focusedBorderColor: primaryColor,
                                    borderColor: grey2,
                                    hintText: "Email",
                                    textController: controller.emailController,
                                    hintColor: primaryColor,
                                    keyBoardType: TextInputType.emailAddress,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 0.0,
                                    ),
                                    focusNode: controller.emailNode,
                                  ),
                                  CustomTextField(
                                    focusedBorderColor: primaryColor,
                                    borderColor: grey2,
                                    hintText: "Social Insurance Number",
                                    textController: controller.sinController,
                                    hintColor: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 0.0,
                                    ),
                                    focusNode: controller.sinNode,
                                  ),
                                  FormDropDown(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 0.0,
                                    ),
                                    question:
                                        "Status of Residence in Year 2024 (Required)",
                                    questionStyle: titleTextStyle,
                                    choices: controller.residencyOptions,
                                    selectedValue:
                                        controller.statusOfResidence.value,
                                    onChanged:
                                        (state) =>
                                            controller.handleS2SingleChange(
                                              selected: state,
                                              resultTextTarget:
                                                  controller.statusOfResidence,
                                              errorText:
                                                  controller
                                                      .residencyStatusError,
                                            ),
                                    focusNode: controller.residencyStatusNode,
                                    errorText:
                                        controller.residencyStatusError.value,
                                  ),
                                ],
                              ),
                              CustomTextButton(
                                title: "Next",
                                onTap: controller.submitStep2,
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
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
