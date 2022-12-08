// Flutter imports:
import 'package:flutter/material.dart';

Size getTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr);
  textPainter.layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
