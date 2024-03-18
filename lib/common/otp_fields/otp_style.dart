import 'package:flutter/material.dart';

class OtpFieldStyle {
  /// The background color for outlined box.
  final Color backgroundColor;

  /// The border color text field.
  final Color borderColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// The border color of text field when disabled.
  final Color disabledBorderColor;

  /// The border color of text field when in focus.
  final Color enabledBorderColor;

  /// The border color of text field when disabled.
  final Color errorBorderColor;

  OtpFieldStyle(
      {this.backgroundColor = Colors.black54,
        this.borderColor = Colors.transparent,
        this.focusBorderColor = Colors.transparent,
        this.disabledBorderColor = Colors.grey,
        this.enabledBorderColor =  Colors.transparent,
        this.errorBorderColor = Colors.red});
}