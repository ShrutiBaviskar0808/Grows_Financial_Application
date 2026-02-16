import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/screens/profile_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

// Make sure primaryColor is your orange and text styles exist

class ProfileSummarySheet extends StatelessWidget {
  final FormController controller;
  final BackdropNavController nav = Get.find();

  ProfileSummarySheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final u = controller.userData; // Map

    // safe getters
    String v(String key) => (u[key] ?? "").toString().trim();

    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: controller.profileVerified.value ? primaryColor : secondaryColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 42,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            "Profile",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Icon(
                      controller.profileVerified.value
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.circle,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Details list
              _dotRow("Name", v('name').trim()),
              _dotRow("Date of Birth", v('dob')),
              _dotRow("Email", v('email')),
              _dotRow("Mobile No.", v('mobile_number')),
              _dotRow("SIN", v('sin')),

              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _whiteButton(
                      icon: FontAwesomeIcons.penToSquare,
                      title: "Edit",
                      onTap: () {
                        Get.back();
                        Get.toNamed(HomeScreen.id);
                        nav.openPage(ProfileScreen.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => _whiteButton(
                        icon: FontAwesomeIcons.userCheck,
                        title:
                            controller.profileVerified.value
                                ? "Verified"
                                : "Verify",
                        onTap:
                            controller.profileVerified.value
                                ? null
                                : () async {
                                  await controller.verifyProfile(); // API call
                                },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dotRow(String label, String value) {
    final showValue = value.isEmpty ? "-" : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
                children: [
                  TextSpan(
                    text: "$label : ",
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: showValue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteButton({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: disabled ? Colors.white.withValues(alpha: 0.7) : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: primaryColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
