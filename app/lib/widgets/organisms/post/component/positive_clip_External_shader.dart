import 'package:flutter/material.dart';

class PositiveClipExternalShader extends CustomPainter {
  const PositiveClipExternalShader({
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.colour,
    required this.radius,
  });

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final Color colour;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path.combine(
      PathOperation.difference,
      Path()
        ..addRect(
          Rect.largest,
        ),
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              paddingLeft,
              paddingTop,
              size.width - paddingRight - paddingLeft,
              size.height - paddingBottom - paddingTop,
            ),
            Radius.circular(radius),
          ),
        ),
    );

    canvas.drawPath(
      path,
      Paint()..color = colour,
    );
  }

  @override
  bool shouldRepaint(PositiveClipExternalShader oldDelegate) => false;
}
