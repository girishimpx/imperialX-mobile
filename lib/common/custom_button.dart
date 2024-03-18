import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCustom extends StatelessWidget {
  final String text;
  final bool iconEnable;
  final double radius;
  final String icon;
  final TextStyle textStyle;
  final Color iconColor;
  final Color shadowColor;
  final Color splashColor;
  final double paddng;

  final VoidCallback onPressed;

  const ButtonCustom(
      {Key? key,
      required this.text,
      required this.iconEnable,
      required this.radius,
      required this.icon,
      required this.textStyle,
      required this.iconColor,
      required this.shadowColor,
      required this.splashColor,
      required this.onPressed,
      required this.paddng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: RawMaterialButton(
        fillColor: shadowColor,
        onPressed: onPressed,
        splashColor: splashColor,
        child: Padding(
          padding: EdgeInsets.only(
              left: paddng, right: paddng, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconEnable
                  ? SvgPicture.asset(
                      icon,
                      height: 15.0,
                      width: 15.0,
                    )
                  : Container(),
              iconEnable
                  ? const SizedBox(
                      width: 10.0,
                    )
                  : Container(),
              Text(
                text,
                maxLines: 1,
                style: textStyle,
              ),
            ],
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}
