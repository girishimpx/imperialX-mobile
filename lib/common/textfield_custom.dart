import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class TextFieldCustom extends StatelessWidget {
  final String hintText, text;
  final bool obscureText, enabled;
  final Function onChanged;
  final TextInputType textInputType;
  final int maxlines;
  final TextInputAction textInputAction;
  final Color textColor;
  final Color fillColor;
  final Color borderColor;
  final String error;
  final Function onEditComplete;
  final TextEditingController controller;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final Widget suffixIcon;


  TextFieldCustom(
      {

        required this.onEditComplete,
        required  this.error,
        required  this.textColor,
        required  this.fillColor,
        required  this.borderColor,
        required this.textInputAction,
        required this.maxlines,
        required this.text,
      required this.hintText,
        required this.obscureText,
        required   this.onChanged,
        required this.enabled,
        required this.textInputType,
        required  this.controller,
        required this.hintStyle,
        required this.textStyle,
        required this.suffixIcon,

      });

  @override
  Widget build(BuildContext context) {
    TextEditingController? _controller =
        text != null ? TextEditingController(text: text) : null;
    if (_controller != null) {
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    }

    return Container(
      padding: EdgeInsets.only(left: 5.0,right: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0,color:borderColor),

          borderRadius: BorderRadius.circular(5.0),


      ),
      child: TextField(
        controller: controller,
        maxLines: maxlines,
        autocorrect: true,
        style: textStyle,
        textInputAction: textInputAction,
        keyboardType: textInputType,

        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 8),
          hintText: hintText,
          hintStyle: hintStyle,
          filled: true,
          fillColor: fillColor,
          suffixIcon: suffixIcon,


        ),

      ),
    );
  }

}
