import 'package:flutter/material.dart';

class TextFormCustom extends StatelessWidget {
  final String hintText, text;
  final bool obscureText, enabled;
  final Function onChanged;
  final TextInputType textInputType;

  final int maxlines;
  final TextInputAction textInputAction;
  final Color textColor;
  final Color borderColor;
  final Color fillColor;
  final String? error;
  final VoidCallback onEditComplete;
  final ValueChanged<String>? textChanged;

  final TextEditingController controller;
  final TextStyle hintStyle;
  final TextStyle textStyle;

  final Widget suffix;
  final Widget prefix;
  final FormFieldValidator<String> validator;
  final FocusNode focusNode;
  final double radius;
  final AutovalidateMode autovalidateMode;

  const TextFormCustom(
      {required this.onEditComplete,
        required this.error,
        required this.textColor,
        required this.borderColor,
        required this.fillColor,
        required this.textInputAction,
        required this.maxlines,
        required this.text,
        required this.hintText,
        required this.obscureText,
        required this.onChanged,
        required this.enabled,
        required this.textInputType,
        required this.controller,
        required this.hintStyle,
        required this.textStyle,
        required this.validator,
        required this.textChanged,
        required this.focusNode,
        required this.radius,
        required this.suffix,
        required this.prefix, required this.autovalidateMode
      });

  @override
  Widget build(BuildContext context) {
    TextEditingController? _controller = TextEditingController(text: text);

    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    return GestureDetector(
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxlines,
        autocorrect: true,
        enabled: enabled,
        style: textStyle,
        autovalidateMode: autovalidateMode,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        onChanged: textChanged,
        onEditingComplete: onEditComplete,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.only(left: 12, right: 0, top: 10, bottom: 10),
          hintText: hintText,
          hintStyle: hintStyle,
          suffixIcon: suffix,
          prefixIcon: prefix,
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          disabledBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(radius)),
            borderSide:
            BorderSide(color: borderColor, width: 1.0),
          ),
          errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
