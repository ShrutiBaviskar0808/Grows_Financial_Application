import 'package:growsfinancial/utils/config.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Color focusedBorderColor;
  final Color borderColor;
  final Color hintColor;
  final String? hintText;
  final String errorText;
  final double borderRadius;
  final double borderWidth;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final Color errorColor;
  final bool password;
  final TextEditingController? textController;
  final int maxLines;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final TextInputType keyBoardType;
  final TextInputAction inputAction;
  final String borderType;
  final EdgeInsets padding;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.focusedBorderColor,
    required this.borderColor,
    this.borderRadius = 10.0,
    required this.hintText,
    this.errorText = "",
    this.leadingIcon,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.errorColor = Colors.white,
    this.borderWidth = 1.0,
    required this.textController,
    this.password = false,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.keyBoardType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
    this.borderType = "round",
    this.hintColor = Colors.white,
    this.inputFormatters,  this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        obscureText: password,
        controller: textController,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        onTap: onTap,
        textAlign: TextAlign.start,
        readOnly: readOnly,
        keyboardType: keyBoardType,
        textInputAction: inputAction,
        focusNode: focusNode,
        style: TextStyle(color: hintColor, fontSize: 18),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          alignLabelWithHint: false,
          filled: borderType == "round" ? true : false,
          prefixIcon: leadingIcon,
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          hintText: hintText,
          errorText: errorText.isNotEmpty ? errorText : null,
          hintStyle: TextStyle(color: hintColor, fontSize: 18),
          // labelText: hintText,
          labelStyle: TextStyle(
            color: grey2.withValues(alpha: 0.4),
            fontSize: 18,

          ),
          focusedBorder: borderType == "round"
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide:
                      BorderSide(color: focusedBorderColor, width: borderWidth),
                )
              : UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: focusedBorderColor, width: borderWidth),
                ),
          enabledBorder: borderType == "round"
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide:
                      BorderSide(width: borderWidth, color: borderColor),
                )
              : UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth),
                ),
          errorBorder: borderType == "round"
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(width: borderWidth, color: errorColor),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: borderWidth),
                ),
          focusedErrorBorder: borderType == "round"
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(width: borderWidth, color: errorColor),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: borderWidth),
                ),
        ),
      ),
    );
  }
}

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    final int oldTextLength = oldValue.text.length;
    final String currentText = newValue.text;

    // Prevent invalid input for month
    if (newTextLength == 1) {
      if (int.tryParse(currentText) == null || int.tryParse(currentText)! > 1) {
        return oldValue;
      }
    }

    if (newTextLength == 2) {
      if (int.tryParse(currentText) == null ||
          int.tryParse(currentText)! > 12) {
        return oldValue;
      }
    }

    // Automatically add '/' after month
    if (newTextLength == 2 && oldTextLength == 1) {
      return TextEditingValue(
        text: '$currentText/',
        selection: const TextSelection.collapsed(offset: 3),
      );
    }

    // Prevent deletion of '/'
    if (newTextLength == 3 && oldTextLength == 4 && currentText[2] != '/') {
      return oldValue;
    }

    // Validate the year
    if (newTextLength > 7) {
      return oldValue;
    }

    if (newTextLength == 5) {
      final int year = int.tryParse(currentText.substring(3)) ?? -1;
      final int currentYear = DateTime.now().year %
          100; // Get the last two digits of the current year

      if (year < currentYear) {
        return TextEditingValue(
          text: '$currentText/',
          selection: const TextSelection.collapsed(offset: 3),
        );
      }
    }

    return newValue;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  Config config = Config();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    int selectionIndex = newValue.selection.end;

    // Determine card type
    String cardType = config.detectCardType(newText);

    // Format card number based on card type
    if (cardType == "Visa" || cardType == "MasterCard") {
      newText = _formatVisaMasterCard(newText);
    } else if (cardType == "AmericanExpress") {
      newText = _formatAmericanExpress(newText);
    }

    // Adjust selection index
    selectionIndex += (newText.length - newValue.text.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _formatVisaMasterCard(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i % 4 == 0 && i != 0) {
        buffer.write(' ');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  String _formatAmericanExpress(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i == 4 || i == 10) {
        buffer.write(' ');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}

class CustomCombinedTextField extends StatelessWidget {
  final Color focusedBorderColor;
  final Color borderColor;
  final Color hintColor;
  final Color errorColor;
  final String? hintText;
  final String? errorText;
  final String? hintText2;
  final String? errorText2;
  final double borderRadius;
  final double borderWidth;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final bool password;
  final TextEditingController? textController;
  final TextEditingController? textController2;
  final int maxLines;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onChanged2;
  final bool readOnly;
  final TextInputType keyBoardType;
  final TextInputAction inputAction;
  final String borderType;
  final EdgeInsets padding;

  const CustomCombinedTextField({
    super.key,
    required this.focusedBorderColor,
    required this.borderColor,
    this.borderRadius = 10.0,
    this.hintText = "",
    this.hintText2 = "",
    this.leadingIcon,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.borderWidth = 1.0,
    required this.textController,
    required this.textController2,
    this.password = false,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.keyBoardType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.onChanged,
    this.onChanged2,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    this.borderType = "round",
    this.hintColor = Colors.white,
    required this.errorColor,
    this.errorText,
    this.errorText2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          TextField(
            obscureText: password,
            controller: textController,
            maxLines: maxLines,
            onTap: onTap,
            textAlign: TextAlign.start,
            readOnly: readOnly,
            keyboardType: keyBoardType,
            textInputAction: inputAction,
            style: TextStyle(color: hintColor),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              alignLabelWithHint: false,
              filled: borderType == "round" ? true : false,
              prefixIcon: leadingIcon,
              suffixIcon: suffixIcon,
              fillColor: fillColor,
              hintText: hintText,
              errorText: errorText!.isEmpty ? null : errorText,
              errorStyle: TextStyle(color: errorColor),
              hintStyle: TextStyle(color: hintColor),
              // labelText: hintText,
              labelStyle: TextStyle(
                color: grey2.withValues(alpha: 0.4),
              ),
              focusedBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    ),
              errorBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      borderSide:
                          BorderSide(width: borderWidth, color: errorColor),
                    )
                  : UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: errorColor, width: borderWidth),
                    ),
              enabledBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      borderSide:
                          BorderSide(width: borderWidth, color: borderColor),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    ),
            ),
          ),
          TextField(
            obscureText: password,
            controller: textController2,
            maxLines: maxLines,
            onTap: onTap,
            textAlign: TextAlign.start,
            readOnly: readOnly,
            keyboardType: keyBoardType,
            textInputAction: inputAction,
            style: TextStyle(color: hintColor),
            onChanged: onChanged2,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              alignLabelWithHint: false,
              filled: borderType == "round" ? true : false,
              prefixIcon: leadingIcon,
              suffixIcon: suffixIcon,
              fillColor: fillColor,
              hintText: hintText2,
              hintStyle: TextStyle(color: hintColor),
              errorText: errorText2!.isEmpty ? null : errorText2,
              errorStyle: TextStyle(color: errorColor),
              // labelText: hintText,
              labelStyle: TextStyle(
                color: grey2.withValues(alpha: 0.4),
              ),
              focusedBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    ),
              enabledBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      borderSide:
                          BorderSide(width: borderWidth, color: borderColor),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: focusedBorderColor, width: borderWidth),
                    ),

              errorBorder: borderType == "round"
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      borderSide:
                          BorderSide(width: borderWidth, color: errorColor),
                    )
                  : UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: errorColor, width: borderWidth),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final Color borderColor;
  final Color hintColor;
  final double borderRadius;
  final double borderWidth;
  final Color fillColor;
  final ValueChanged<String?>? onChanged;
  final String borderType;
  final String selected;
  final List<String> list;

  const CustomDropDown({
    super.key,
    required this.borderColor,
    required this.hintColor,
    required this.borderRadius,
    this.borderWidth = 1.0,
    required this.fillColor,
    this.onChanged,
    this.borderType = "round",
    required this.selected,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius:
            borderType == "round" ? BorderRadius.circular(borderRadius) : null,
        border: borderType == "round"
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          // Use suffixIcon if it represents the dropdown icon
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    color: hintColor, fontSize: 14), // Match TextField style
              ),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(color: hintColor, fontSize: 14),
          elevation: 0,
          borderRadius: BorderRadius.circular(10.0),
          // Style text within dropdown
          dropdownColor: primaryColor, // Set dropdown menu background color
        ),
      ),
    );
  }
}
