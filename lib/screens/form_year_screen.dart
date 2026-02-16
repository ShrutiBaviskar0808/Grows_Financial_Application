import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormYearScreen extends StatelessWidget {
  static const String id = "/FormYearScreen";

  FormYearScreen({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          automaticallyImplyLeading: true,
          onTap: () {
            Get.back();
          },
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: controller.showSpinner.value
              ? controller.config.loadingView()
              : CommonSafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Center(
                                child: Text(
                                  "New Tax File",
                                  style: titleTextStyle.copyWith(fontSize: 24),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            //Form Fields
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'FOR WHICH YEAR DO YOU WANT TO APPLY FOR? SELECT THAT APPLY:',
                                        style: titleTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 26),
                                      ...controller.years.map((year) {
                                        bool selected =
                                            controller.period.value == year;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7,
                                          ),
                                          child: GestureDetector(
                                            onTap:
                                                () => controller.selectPeriod(
                                                  year,
                                                ),
                                            child: AnimatedContainer(
                                              duration: Duration(
                                                milliseconds: 150,
                                              ),
                                              width: double.infinity,
                                              height: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color:
                                                    selected
                                                        ? primaryColor
                                                        : Colors.white,
                                                border: Border.all(
                                                  color: primaryColor,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '$year',
                                                style: TextStyle(
                                                  color:
                                                      selected
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 70),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                            bottom: 10.0,
                          ),
                          child: CustomTextButton(
                            title: "Next",
                            onTap: controller.submitForm,
                            width: width,
                            height: 56,
                            color: primaryColor,
                            borderRadius: 15.0,
                            textStyle: titleTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
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
