import 'package:growsfinancial/utils/constant.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = secondaryColor,
    this.borderRadius = 25,
    this.height = 30,
    this.width = 50,
    this.textStyle = const TextStyle(
      color: textColor,
      fontFamily: 'Outfit-SemiBold',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.borderColor = Colors.transparent,
    this.splashColor = Colors.transparent,
  });

  final VoidCallback onTap;
  final String title;
  final Color color;
  final Color splashColor;
  final double borderRadius;
  final double height;
  final double width;
  final TextStyle textStyle;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: splashColor,
          onTap: onTap,
          enableFeedback: false,
          child: Container(
            alignment: Alignment.center,
            child: Text(title, style: textStyle),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.buttonColor = Colors.white,
    this.size = 20,
  });

  final GestureTapCallback onTap;
  final IconData icon;
  final Color buttonColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      child: Container(
        alignment: Alignment.center,
        child: Icon(icon, size: size, color: buttonColor),
      ),
    );
  }
}

class CustomRoundIconButton extends StatelessWidget {
  const CustomRoundIconButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.imageHeight = 30,
    this.imageWidth = 50,
    this.buttonColor = Colors.white,
    this.iconColor = Colors.white,
    this.height = 60,
    this.width = 60,
  });

  final VoidCallback onTap;
  final String icon;
  final String title;
  final Color buttonColor;
  final Color iconColor;
  final double height;
  final double width;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(40.0),
            ),
            height: height,
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                icon,
                height: height,
                width: width,
                color: iconColor,
              ),
            ),
          ),
          Text(
            title,
            style: titleTextStyle.copyWith(
              fontSize: 12,
              fontWeight: regularFont,
              height: 0,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextIconButton extends StatelessWidget {
  const CustomTextIconButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
    this.color = secondaryColor,
    this.borderRadius = 25,
    this.height = 30,
    this.width = 50,
    this.iconSize = 12.0,
    this.textStyle = const TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
    ),
    this.orientation = "right",
    this.borderColor = Colors.transparent,
    this.splashColor = Colors.transparent,
  });

  final VoidCallback onTap;
  final String title;
  final String icon;

  final Color color;
  final Color iconColor;
  final Color splashColor;
  final double borderRadius;
  final double height;
  final double width;
  final double iconSize;
  final TextStyle textStyle;
  final String orientation;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        color: color,
      ),
      child: InkWell(
        splashColor: splashColor,
        onTap: onTap,
        enableFeedback: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: orientation == "left" ? true : false,
              child: Row(
                children: [
                  Image.asset(icon, color: iconColor, height: iconSize),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Text(title, textAlign: TextAlign.center, style: textStyle),

            Visibility(
              visible: orientation == "right" ? true : false,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Image.asset(icon, color: iconColor, height: iconSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final Color color;
  final Icon icon;
  final GestureTapCallback onTap;

  const RoundIconButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color,
      ),
      child: InkWell(
        onTap: onTap,
        enableFeedback: false,
        child: Padding(padding: const EdgeInsets.all(10.0), child: icon),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;

  const CustomBackButton({
    super.key,
    required this.onTap,
    this.iconData = Icons.arrow_back_ios_new,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      child: Icon(iconData, size: 20, color: Colors.white),
    );
  }
}

class RadioButton extends StatelessWidget {
  final Color textColor;
  final int groupValue;
  final int value;
  final String text;
  final ValueChanged<int?> onChange;

  const RadioButton({
    super.key,
    required this.textColor,
    required this.groupValue,
    required this.onChange,
    required this.value,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioGroup(
          groupValue: groupValue,
          onChanged: onChange,
          child: Radio(
            value: value,
            activeColor: primaryColor,
          ),
        ),
        Text(
          text,
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
            fontWeight: regularFont,
            color: value == groupValue ? primaryColor : textColor,
          ),
        ),
      ],
    );
  }
}

class CheckButton extends StatelessWidget {
  final Color textColor;
  final bool value;
  final String text;
  final ValueChanged<bool?> onChange;

  const CheckButton({
    super.key,
    required this.textColor,
    required this.onChange,
    required this.value,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChange, activeColor: primaryColor),
        Text(
          text,
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
            fontWeight: regularFont,
            color: value ? primaryColor : textColor,
          ),
        ),
      ],
    );
  }
}
