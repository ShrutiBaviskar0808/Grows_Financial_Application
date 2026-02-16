import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/header_raw.dart';
import 'package:growsfinancial/components/profile_summary_sheet.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/form_t1_step1_screen.dart';
import 'package:growsfinancial/screens/form_year_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormStepScreen extends StatefulWidget {
  static const String id = "/FormStepScreen";

  const FormStepScreen({super.key});

  @override
  State<FormStepScreen> createState() => _FormStepScreenState();
}

class _FormStepScreenState extends State<FormStepScreen> {
  final FormController controller = Get.find();

  final BackdropNavController nav = Get.find();

  @override
  void initState() {
    super.initState();
    final arguments = (Get.arguments ?? {}) as Map;
    controller.serviceID.value = arguments['serviceID']?.toString() ?? '';
    controller.newRequest.value = arguments['newRequest'] ?? false;
    controller.getUser();
    controller.formYears();
    if (!controller.newRequest.value) {
      controller.getServiceDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: CommonSafeArea(
          child: Column(
          children: [
            HeaderRaw(
              userName: controller.userData['name'] ?? "",
              profileImage: "",
              isMenuVisible: false,
            ),

            // White rounded container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    // inner light card like screenshot
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 28,
                            ),
                          ),

                          const SizedBox(height: 14),

                          OrangeOptionTile(
                            leftIcon: "assets/icons/calendar.png",
                            title:
                                controller.period.value.isEmpty
                                    ? "Year"
                                    : controller.period.value,
                            rightIcon: FontAwesomeIcons.caretDown,
                            onTap: () {
                              Get.toNamed(
                                FormYearScreen.id,
                                arguments: {
                                  "serviceID": controller.serviceID.value,
                                  "type": controller.type.value,
                                  "serviceName": controller.serviceName,
                                },
                              );
                            },
                            backgroundColor:
                                controller.period.value.isNotEmpty
                                    ? primaryColor
                                    : secondaryColor,
                          ),
                          const SizedBox(height: 12),
                          OrangeOptionTile(
                            leftIcon: "assets/icons/profile-circle.png",
                            title: "Profile",
                            rightIcon: FontAwesomeIcons.circleCheck,
                            onTap: () {
                              Get.bottomSheet(
                                ProfileSummarySheet(controller: controller),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            },
                            backgroundColor:
                                controller.profileVerified.value
                                    ? primaryColor
                                    : secondaryColor,
                          ),
                          const SizedBox(height: 12),
                          OrangeOptionTile(
                            leftIcon: "assets/icons/tax-info.png",
                            title: "Tax Info",
                            rightIcon: FontAwesomeIcons.play,
                            onTap: () {
                              if (controller.period.isNotEmpty) {
                                Get.toNamed(FormT1Step1Screen.id);
                              } else {
                                controller.config.showToastFailure(
                                  "Please Select Year First",
                                );
                              }
                            },
                            backgroundColor:
                                controller.formFilled.value
                                    ? primaryColor
                                    : secondaryColor,
                          ),
                          const SizedBox(height: 12),
                          OrangeOptionTile(
                            leftIcon: "assets/icons/t-slip.png",
                            title: "T-slip",
                            rightIcon: FontAwesomeIcons.play,
                            onTap: () {
                              if (controller.period.isNotEmpty) {
                                Get.toNamed(FormT1Step1Screen.id,arguments: {
                                  "serviceID": controller.serviceID.value,
                                  "type": controller.type.value,
                                  "serviceName": controller.serviceName,
                                },);
                              } else {
                                controller.config.showToastFailure(
                                  "Please Select Year First",
                                );
                              }
                            },
                            backgroundColor:
                                controller.formFilled.value
                                    ? primaryColor
                                    : secondaryColor,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Submit button
                    CustomTextIconButton(
                      title: "Submit Form",
                      icon: "assets/icons/click.png",
                      onTap: () {
                        final msg = controller.submitErrorMessage();
                        if (msg != null) {
                          controller.config.showToastFailure(
                            msg,
                          ); // or Get.snackbar(...)
                          return;
                        }

                        // ✅ All validations passed
                        Get.offNamedUntil(
                          HomeScreen.id,
                          ModalRoute.withName(HomeScreen.id),
                        );
                        nav.openPage(AccountsScreen.id);
                      },
                      width: width,
                      height: 46,
                      color: primaryColor,
                      borderRadius: 50,
                      borderColor: primaryColor,
                      iconColor: Colors.white,
                      iconSize: 20,
                      textStyle: titleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class OrangeOptionTile extends StatelessWidget {
  final String leftIcon;
  final String title;
  final IconData rightIcon;
  final VoidCallback onTap;
  final Color backgroundColor;

  const OrangeOptionTile({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.rightIcon,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // left icon in white outlined circle (like screenshot)
            Image.asset(leftIcon, color: Colors.white, height: 16),
            const SizedBox(width: 12),

            // white pill text
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Icon(rightIcon, color: primaryColor, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
