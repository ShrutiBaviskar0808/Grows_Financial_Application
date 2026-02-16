import 'package:flutter/material.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:growsfinancial/utils/string_extension.dart';

class CustomerDetailRaw extends StatelessWidget {
  final String title, detail;

  const CustomerDetailRaw({
    super.key,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small grey label: "First Name", "Email"
          Text(
            title.capitalize(),
            style: titleTextStyle.copyWith(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          // Big bold value: "Sunil mistry", "Mistrysam11@gmail.com"
          Text(
            detail,
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
