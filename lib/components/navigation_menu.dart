import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/profile_screen.dart';
import 'package:growsfinancial/screens/reset_password_screen.dart';

class NavigationMenu extends StatelessWidget {
  final BackdropNavController nav = Get.put(BackdropNavController());
  final AuthController auth = Get.find();
  final AccountController account = Get.put(AccountController());
  final AccountController controller = Get.find();
  final VoidCallback? onClose;

  NavigationMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 30),
      children: [
        const SizedBox(height: 20),

        _menuButton(
          title: "Dashboard",
          icon: FontAwesomeIcons.house,
          onTap: () {
            onClose?.call();
            nav.openPage(AccountsScreen.id);
          },
        ),

        const SizedBox(height: 14),

        _menuButton(
          title: "Change Profile",
          icon: FontAwesomeIcons.userPen,
          onTap: () {
            onClose?.call();
            Get.toNamed(ProfileScreen.id);
          },
        ),

        const SizedBox(height: 14),

        _menuButton(
          title: "Change Password",
          icon: FontAwesomeIcons.lock,
          onTap: () {
            onClose?.call();
            Get.toNamed(ResetPasswordScreen.id);
          },
        ),

        const SizedBox(height: 14),

        _menuButton(
          title: "Contact Us",
          icon: FontAwesomeIcons.phone,
          onTap: () {
            onClose?.call();
            controller.config.launchURL(
              'https://growsfinancial.ca/contact-us/',
            );
          },
        ),

        const SizedBox(height: 14),

        _menuButton(
          title: "Useful Info",
          icon: FontAwesomeIcons.circleInfo,
          onTap: () {
            onClose?.call();
            controller.config.launchURL('https://growsfinancial.ca/');
          },
        ),

        const SizedBox(height: 14),

        _menuButton(
          title: "Logout",
          icon: FontAwesomeIcons.powerOff,
          onTap: () {
            onClose?.call();
            auth.logout();
          },
        ),

        const SizedBox(height: 26),

        _menuButton(
          title: "Back to Home",
          icon: null,
          showArrow: true,
          onTap: () {
            onClose?.call();
          },
        ),
      ],
    );
  }

  // ==============================
  // CUSTOM PILL BUTTON DESIGN
  // ==============================
  Widget _menuButton({
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return Align(
      alignment: Alignment.centerRight, // ✅ right aligned
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 58,
          width: MediaQuery.of(Get.context!).size.width * 0.70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0B2E4A),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 20),

              if (icon != null) const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                )
              else
                const SizedBox(width: 24), // keeps center alignment
            ],
          ),
        ),
      ),
    );
  }
}
