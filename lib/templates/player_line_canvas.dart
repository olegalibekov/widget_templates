import 'package:flutter/material.dart';

class PlayerLineCanvas extends CustomPainter {
  final double _lineLength = 100.0;
  final double _maxLineHeight = 16.0;
  final double _thickness = 2.5;

  double get _minLineHeight => _maxLineHeight / 2;

  double get _thicknessPadding => _thickness / 2;

  Paint get _paint {
    Paint paint = Paint()
      ..color = Color.fromRGBO(52, 52, 52, 1)
      ..strokeWidth = _thickness;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int lineNumber = 0; lineNumber < 1; lineNumber++) {
      createOneLine(canvas, _lineLength * lineNumber);
    }
  }

  createOneLine(Canvas canvas, startPaddingX) {
    canvas.drawLine(Offset(startPaddingX, 0.0),
        Offset(startPaddingX + _lineLength, 0.0), _paint);
    canvas.drawLine(Offset(startPaddingX + _thicknessPadding, 0.0),
        Offset(startPaddingX + _thicknessPadding, -_maxLineHeight), _paint);
    for (int minHeightLineNumber = 1;
        minHeightLineNumber <= 9;
        minHeightLineNumber++) {
      double xPadding = minHeightLineNumber * _lineLength / 10.0;
      canvas.drawLine(
          Offset(startPaddingX + xPadding + _thicknessPadding, 0.0),
          Offset(startPaddingX + xPadding + _thicknessPadding, -_minLineHeight),
          _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
