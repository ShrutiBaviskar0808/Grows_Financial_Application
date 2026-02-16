import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/utils/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;

  final bool automaticallyImplyLeading;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final bool roundBorder;

  const CustomAppBar({
    super.key,
    this.roundBorder = true,
    this.actions,
    this.leading,
    this.onTap,
    this.automaticallyImplyLeading = true,
    this.backgroundColor = primaryColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      // Set this height to whatever you need
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "GROWS",
            style: titleTextStyle.copyWith(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 5,
            ),
          ),
        ),
        leading:
            automaticallyImplyLeading
                ? CustomBackButton(onTap: onTap ?? () => Get.back())
                : leading,
        actions: actions,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        // Additional AppBar properties can be added here
      ),
    );
  }
}
