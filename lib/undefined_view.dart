import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  final String name;

  const UndefinedView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$name Page Not Found',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
