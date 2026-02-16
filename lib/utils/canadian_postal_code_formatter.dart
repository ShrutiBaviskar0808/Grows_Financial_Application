import 'package:flutter/services.dart';

class CanadianPostalCodeFormatter extends TextInputFormatter {
  static final _allowedLetter = RegExp(r'[ABCEGHJ-NPRSTVXY]');
  static final _allowedDigit = RegExp(r'\d');

  String _sanitize(String input) =>
      input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final raw = _sanitize(newValue.text);

    final buf = StringBuffer();
    int rawIndex = 0;

    while (rawIndex < raw.length && buf.length < 7) {
      switch (buf.length) {
        case 0: // L
          if (_allowedLetter.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
        case 1: // D
          if (_allowedDigit.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
        case 2: // L
          if (_allowedLetter.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
        case 3: // auto space
          buf.write(' ');
          continue; // don’t advance rawIndex, re-check same char at next slot
        case 4: // D
          if (_allowedDigit.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
        case 5: // L
          if (_allowedLetter.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
        case 6: // D
          if (_allowedDigit.hasMatch(raw[rawIndex])) {
            buf.write(raw[rawIndex]);
          }
          break;
      }
      rawIndex++;
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static bool isValid(String input) {
    final pattern = RegExp(
      r'^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z] \d[ABCEGHJ-NPRSTV-Z]\d$',
    );
    return pattern.hasMatch(input.trim().toUpperCase());
  }
}
