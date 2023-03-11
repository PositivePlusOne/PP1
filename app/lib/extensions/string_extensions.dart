// Flutter imports:
import 'package:flutter/material.dart';

extension StringExtensions on String {
  Size getTextSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: this, style: style), maxLines: 1, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  String get asHandle => '@$this';
}
