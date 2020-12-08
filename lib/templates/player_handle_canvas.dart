import 'package:flutter/widgets.dart';

class PlayerHandleCanvas extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('paint');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
