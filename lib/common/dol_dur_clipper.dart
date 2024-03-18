import 'package:flutter/material.dart';

class DolDurClipper extends CustomClipper<Path> {
  DolDurClipper({required this.right, required this.holeRadius, required this.topClockwise, required this.bottomClockwise});

  final double right;
  final double holeRadius;
  final bool topClockwise;
  final bool bottomClockwise;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: topClockwise,
        radius: Radius.circular(1),
      )
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: bottomClockwise,
        radius: Radius.circular(1),
      );

    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurClipper oldClipper) => true;
}