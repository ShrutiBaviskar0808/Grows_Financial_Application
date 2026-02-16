import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/form_raw.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormT1Step2Screen extends StatelessWidget {
  static const String id = "/FormT1Step2Screen";

  FormT1Step2Screen({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return  Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: controller.showSpinner.value
              ? controller.config.loadingView()
              : CommonSafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Personal Tax File - Step 2",
                            style: titleTextStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        SizedBox(height: 15),
                        //Form Fields
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question:
                                  "Select the option below for Salaried Employees",
                              questionStyle: titleTextStyle,
                              choices: controller.salariedEmployeesOptions,
                              selectedValue:
                                  controller.selectedSalariedEmployees,
                              onChanged:
                                  (state) =>
                                      controller.handleS2MultiChange<String>(
                                        selected: state,
                                        selectedValuesTarget:
                                            controller
                                                .selectedSalariedEmployees,
                                      ),
                              focusNode: controller.salariedEmployeesNode,
                            ),
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question: "Select the option below for studying",
                              questionStyle: titleTextStyle,
                              choices: controller.studyingOptions,
                              selectedValue: controller.selectedStudying,
                              onChanged:
                                  (state) =>
                                      controller.handleS2MultiChange<String>(
                                        selected: state,
                                        selectedValuesTarget:
                                            controller.selectedStudying,
                                      ),
                              focusNode: controller.studyOptionsNode,
                            ),
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question:
                                  "Select the option below for doing Business and Renting property",
                              questionStyle: titleTextStyle,
                              choices:
                                  controller.businessRentingPropertyOptions,
                              selectedValue:
                                  controller.selectedBusinessRentingProperty,
                              onChanged:
                                  (
                                    state,
                                  ) => controller.handleS2MultiChange<String>(
                                    selected: state,
                                    selectedValuesTarget:
                                        controller
                                            .selectedBusinessRentingProperty,
                                  ),
                              focusNode: controller.businessRentingPropertyNode,
                            ),
                            FormMultiDropDown<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0.0,
                              ),
                              question:
                                  "Select the option below for any investments or expenses.",
                              questionStyle: titleTextStyle,
                              choices: controller.investmentExpensesOptions,
                              selectedValue:
                                  controller.selectedInvestmentExpenses,
                              onChanged:
                                  (state) =>
                                      controller.handleS2MultiChange<String>(
                                        selected: state,
                                        selectedValuesTarget:
                                            controller
                                                .selectedInvestmentExpenses,
                                      ),
                              focusNode: controller.investmentExpensesNode,
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
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
    );
  }
}
