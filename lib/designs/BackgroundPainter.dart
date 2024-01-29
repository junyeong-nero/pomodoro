import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {

  List<Color> theme = [];
  int value = 0;
  BackgroundPainter(this.theme, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = theme[0]
      ..isAntiAlias = true;

    canvas.drawArc(rect, 270 * pi / 180, (value / 3600 * 360) * pi / 180, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}