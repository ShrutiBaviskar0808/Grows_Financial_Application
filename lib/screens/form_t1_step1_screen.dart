import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/components/form_raw.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormT1Step1Screen extends StatelessWidget {
  static const String id = "/FormT1Step1Screen";

  FormT1Step1Screen({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  "Personal Tax File - Step 1",
                  style: titleTextStyle.copyWith(fontSize: 24),
                ),
              ),
              SizedBox(height: 15),
              //Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Basic Information
                        /*FormBasicInfoRaw(
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
                            errorText: controller.dobError,
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


                          },
                          middleNameOnChanged: (text) {
                            controller.middleNameError.value = "";

                          },
                          lastNameOnChanged: (text) {
                            controller.lastNameError.value = "";

                          },
                        ),*/
                        //Current Address
                        FormAddressRaw(
                          title:
                          "Full current address for CRA mailing purposes (Required)",
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
                          postalCodeNode:
                          controller.currentPostalCodeNode,
                          stateNode: controller.currentStateNode,
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
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Did you live at the same address on December 31st, 2024? (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue: controller.sameAddress.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.sameAddress,
                            errorText:
                            controller.sameAddressError,
                          ),
                          focusNode: controller.sameAddressNode,
                          errorText:
                          controller.sameAddressError.value,
                        ),
                        Obx(() => Visibility(
                            visible:
                            controller.sameAddress.value == "No",
                            child: FormAddressRaw(
                              title:
                              "Full Address on December 31,2024 (Required)",
                              address1Controller:
                              controller.address1Controller,
                              address2Controller:
                              controller.address2Controller,
                              cityController: controller.cityController,
                              postalCodeController:
                              controller.postalCodeController,
                              list: controller.statesOptions,
                              selectedValue: controller.state.value,
                              onChanged:
                                  (state) => controller
                                  .handleS2SingleChange<String>(
                                selected: state,
                                resultTextTarget:
                                controller.state,
                                errorText:
                                controller.stateError,
                              ),
                              address1Node: controller.address1Node,
                              address2Node: controller.address2Node,
                              cityNode: controller.cityNode,
                              stateNode: controller.stateNode,
                              postalCodeNode: controller.postalCodeNode,
                              address1Error:
                              controller.address1Error.value,
                              address2Error:
                              controller.address2Error.value,
                              cityError: controller.cityError.value,
                              stateError: controller.stateError.value,
                              postalCodeError:
                              controller.postalCodeError.value,
                            ),
                          ),
                        ),
                        /*Padding(
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
                          errorText: controller.emailError.value,
                          onChanged: (text) {
                            controller.emailError.value = "";

                          },
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
                          errorText: controller.sinError.value,
                          onChanged: (text) {
                            controller.sinError.value = "";

                          },
                        ),*/
                        FormDropDown<String>(
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
                              (state) => controller
                              .handleS2SingleChange<String>(
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
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Marital Status as of December 31st, 2024 (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.maritalOptions,
                          selectedValue:
                          controller.maritalStatus.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.maritalStatus,
                            errorText:
                            controller.maritalStatusError,
                          ),
                          focusNode: controller.maritalStatusNode,
                          errorText:
                          controller.maritalStatusError.value,
                        ),
                        Obx(() => Visibility(
                            visible:
                            controller.maritalStatus.value ==
                                "Married",
                            child: Column(
                              children: [
                                FormDropDown<String>(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 0.0,
                                  ),
                                  question:
                                  "Is your spouse in Canada on December 31st, 2024?(Required)",
                                  questionStyle: titleTextStyle,
                                  choices: controller.yesNoOptions,
                                  selectedValue:
                                  controller.spouseStatus.value,
                                  onChanged:
                                      (state) => controller
                                      .handleS2SingleChange<String>(
                                    selected: state,
                                    resultTextTarget:
                                    controller.spouseStatus,
                                    errorText:
                                    controller
                                        .spouseStatusError,
                                  ),
                                  focusNode:
                                  controller.spouseStatusNode,
                                  errorText:
                                  controller
                                      .spouseStatusError
                                      .value,
                                ),
                                Obx(() => Visibility(
                                    visible:
                                    controller.spouseStatus.value ==
                                        "Yes",
                                    child: Text(
                                      "Once you have completed this form, please fill out the same form for your spouse. If your spouse has already filled out this form, no further action is required after you finish your form.",
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FormBasicInfoRaw(
                                  title: "Spouse Details (Required)",
                                  firstNameController:
                                  controller
                                      .spouseFirstNameController,
                                  middleNameController:
                                  controller
                                      .spouseMiddleNameController,
                                  lastNameController:
                                  controller
                                      .spouseLastNameController,
                                  dobController:
                                  controller.spouseDobController,
                                  onTap:
                                      () => controller.handleDatePick(
                                    context: context,
                                    currentDate:
                                    controller.currentDate,
                                    controller:
                                    controller
                                        .spouseDobController,
                                    value: controller.spouseDob,
                                    errorText:
                                    controller.spouseDobError,
                                  ),
                                  firstNameError:
                                  controller
                                      .spouseFirstNameError
                                      .value,
                                  middleNameError:
                                  controller
                                      .spouseMiddleNameError
                                      .value,
                                  lastNameError:
                                  controller
                                      .spouseLastNameError
                                      .value,
                                  dobError:
                                  controller.spouseDobError.value,
                                  firstNameNode:
                                  controller.spouseFirstNameNode,
                                  middleNameNode:
                                  controller.spouseMiddleNameNode,
                                  lastNameNode:
                                  controller.spouseLastNameNode,
                                  dobNode: controller.spouseDobNode,
                                  firstNameOnChanged: (text) {
                                    controller
                                        .spouseFirstNameError
                                        .value = "";

                                  },
                                  middleNameOnChanged: (text) {
                                    controller
                                        .spouseMiddleNameError
                                        .value = "";

                                  },
                                  lastNameOnChanged: (text) {
                                    controller
                                        .spouseLastNameError
                                        .value = "";

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Did your marital status change at any time during the year 2024?(Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.maritalStatusChange.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller
                                .maritalStatusChange,
                            errorText:
                            controller
                                .maritalStatusChangeError,
                          ),
                          errorText:
                          controller
                              .maritalStatusChangeError
                              .value,
                          focusNode:
                          controller.maritalStatusChangeNode,
                        ),
                        Obx(() => Visibility(
                            visible:
                            controller.maritalStatusChange.value ==
                                "Yes",
                            child: CustomTextField(
                              focusedBorderColor: primaryColor,
                              borderColor: grey2,
                              hintText:
                              "Date of Marital status change in 2024 (Required)",
                              textController:
                              controller
                                  .maritalStatusChangeDateController,
                              hintColor: primaryColor,
                              onTap:
                                  () => controller.handleDatePick(
                                context: context,
                                currentDate: controller.currentDate,
                                controller:
                                controller
                                    .maritalStatusChangeDateController,
                                value: controller.maritalStatusDate,
                                errorText:
                                controller
                                    .maritalStatusChangeDateError,
                              ),
                              readOnly: true,
                              focusNode:
                              controller
                                  .maritalStatusChangeDateNode,
                              errorText:
                              controller
                                  .maritalStatusChangeDateError
                                  .value,
                              onChanged: (text) {
                                controller
                                    .maritalStatusChangeDateError
                                    .value = "";

                              },
                            ),
                          ),
                        ),
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Do you have any dependent children in Canada ? (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.dependentChildren.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.dependentChildren,
                            errorText:
                            controller
                                .childDependentError,
                          ),
                          focusNode: controller.dependentChildrenNode,
                          errorText:
                          controller.childDependentError.value,
                        ),
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Do you have any dependent parent in Canada ? (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.dependentParent.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.dependentParent,
                            errorText:
                            controller
                                .parentDependentError,
                          ),
                          focusNode: controller.dependentParentNode,
                          errorText:
                          controller.parentDependentError.value,
                        ),
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "First time filing taxes in Canada? (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.firstTimeFilling.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.firstTimeFilling,
                            errorText:
                            controller
                                .firstTimeFillingError,
                          ),
                          focusNode: controller.firstTimeFillingNode,
                          errorText:
                          controller.firstTimeFillingError.value,
                        ),
                        Obx(() => Visibility(
                            visible:
                            controller.firstTimeFilling.value ==
                                "Yes",
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    "If it's your first time filing taxes in Canada, please provide your Date of Arrival. (Required)",
                                    style: titleTextStyle,
                                  ),
                                ),
                                CustomTextField(
                                  focusedBorderColor: primaryColor,
                                  borderColor: grey2,
                                  hintText: "Select Date",
                                  textController:
                                  controller
                                      .dateOfArrivalController,
                                  hintColor: primaryColor,
                                  onTap:
                                      () => controller.handleDatePick(
                                    context: context,
                                    currentDate:
                                    controller.currentDate,
                                    controller:
                                    controller
                                        .dateOfArrivalController,
                                    value: controller.dateArrival,
                                  ),
                                  readOnly: true,
                                  focusNode:
                                  controller.dateOfArrivalNode,
                                  errorText:
                                  controller.arrivalDateError.value,
                                  onChanged: (text) {
                                    controller.arrivalDateError.value =
                                    "";

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          "Would you like to file your tax return for 2023 or earlier? (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.fileForEarlier.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.fileForEarlier,
                            errorText:
                            controller
                                .fileForEarlierError,
                          ),
                          focusNode: controller.fileForEarlierNode,
                          errorText:
                          controller.fileForEarlierError.value,
                        ),
                        Obx(() => Visibility(
                            visible:
                            controller.fileForEarlier.value ==
                                "Yes",
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
                                  (state) => controller
                                  .handleS2MultiChange<String>(
                                selected: state,
                                selectedValuesTarget:
                                controller.selectedYears,
                                errorText:
                                controller.taxYearsError,
                              ),
                              focusNode: controller.taxYearsNode,
                              errorText: controller.taxYearsError.value,
                            ),
                          ),
                        ),

                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          'Have you created your "My CRA account"? (Required)',
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue: controller.craAccount.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.craAccount,
                            errorText:
                            controller.craAccountError,
                          ),
                          focusNode: controller.craAccountNode,
                          errorText: controller.craAccountError.value,
                        ),

                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          question:
                          'Have you created your "My Business account"? (Required)',
                          questionStyle: titleTextStyle,
                          choices: controller.yesNoOptions,
                          selectedValue:
                          controller.businessAccount.value,
                          onChanged:
                              (state) => controller
                              .handleS2SingleChange<String>(
                            selected: state,
                            resultTextTarget:
                            controller.businessAccount,
                            errorText:
                            controller
                                .businessAccountError,
                          ),
                          focusNode: controller.businessAccountNode,
                          errorText:
                          controller.businessAccountError.value,
                        ),
                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Name of referring person",
                          textController: controller.referController,
                          hintColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
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
              SizedBox(height: 20),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
