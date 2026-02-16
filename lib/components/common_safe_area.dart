import 'package:flutter/material.dart';

class CommonSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final Color? backgroundColor;

  const CommonSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: child,
      ),
    );
  }
}
