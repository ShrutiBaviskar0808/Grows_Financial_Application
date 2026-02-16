import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/components/form_raw.dart';

import 'package:growsfinancial/controllers/bookkeeping_form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class BookKeepingFormScreen extends StatelessWidget {
  static const String id = "/BookKeepingFormScreen";

  BookKeepingFormScreen({super.key});

  final BookkeepingFormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            "Bookkeeping Form",
                            style: titleTextStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ===== Fiscal Year End =====
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          question: "Fiscal Year end (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.fiscalYearEndOptions,
                          selectedValue: controller.fiscalYearEnd.value,
                          onChanged:
                              (v) => controller.handleS2SingleChange<String>(
                                selected: v,
                                resultTextTarget: controller.fiscalYearEnd,
                                errorText: controller.fiscalYearEndError,
                              ),
                          errorText: controller.fiscalYearEndError.value,
                          focusNode: controller.fiscalYearEndNode,
                        ),

                        // ===== Numbers =====
                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of Bank accounts",
                          textController: controller.bankAccountsController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.bankAccountsError.value,
                          onChanged:
                              (_) => controller.bankAccountsError.value = "",
                        ),

                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of credit cards accounts",
                          textController: controller.creditCardsController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.creditCardsError.value,
                          onChanged:
                              (_) => controller.creditCardsError.value = "",
                        ),

                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of line of credit",
                          textController: controller.lineOfCreditController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.lineOfCreditError.value,
                          onChanged:
                              (_) => controller.lineOfCreditError.value = "",
                        ),

                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of loan",
                          textController: controller.loanController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.loanError.value,
                          onChanged: (_) => controller.loanError.value = "",
                        ),

                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of staff employee",
                          textController: controller.staffEmployeeController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.staffEmployeeError.value,
                          onChanged:
                              (_) => controller.staffEmployeeError.value = "",
                        ),

                        // ===== Bookkeeping software =====
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          question: "Bookkeeping software (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.bookkeepingSoftwareOptions,
                          selectedValue: controller.bookkeepingSoftware.value,
                          onChanged:
                              (v) => controller.handleS2SingleChange<String>(
                                selected: v,
                                resultTextTarget:
                                    controller.bookkeepingSoftware,
                                errorText: controller.bookkeepingSoftwareError,
                              ),
                          errorText: controller.bookkeepingSoftwareError.value,
                          focusNode: controller.bookKeepingSoftwareNode,
                        ),

                        // ===== Partners & Owner =====
                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Number of partner and owner",
                          textController: controller.partnersOwnersController,
                          hintColor: primaryColor,
                          keyBoardType: TextInputType.number,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          errorText: controller.partnersOwnersError.value,
                          onChanged:
                              (_) => controller.partnersOwnersError.value = "",
                        ),

                        // ===== Frequency of work =====
                        FormDropDown<String>(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          question: "Frequency of work (Required)",
                          questionStyle: titleTextStyle,
                          choices: controller.frequencyOptions,
                          selectedValue: controller.frequencyOfWork.value,
                          onChanged: (v) => controller.onFrequencyChanged(v),
                          errorText: controller.frequencyOfWorkError.value,
                          focusNode: controller.frequencyNode,
                        ),

                        // ===== Folder created by frequency (auto) =====
                        CustomTextField(
                          focusedBorderColor: primaryColor,
                          borderColor: grey2,
                          hintText: "Folder created by frequency",
                          textController:
                              controller.folderByFrequencyController,
                          hintColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          readOnly: true,
                        ),

                        const SizedBox(height: 12),

                        CustomTextButton(
                          title: "Submit",
                          onTap: controller.submitBookkeepingForm,
                          width: width,
                          height: 56,
                          color: primaryColor,
                          borderRadius: 15,
                          textStyle: titleTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
