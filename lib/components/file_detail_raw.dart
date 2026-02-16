import 'package:flutter/material.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/utils/constant.dart';

class FileDetailRaw extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FileDetailRaw({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleTextStyle.copyWith(fontSize: 18)),
        CustomIconButton(
          icon: Icons.download_rounded,
          onTap: onTap,
          size: 25,
          buttonColor: primaryColor,
        ),

      ],
    );
  }
}
