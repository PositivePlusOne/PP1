// Package imports:
import 'package:flutter/material.dart';

//? Universal input formatter to prevent successive new lines
Size getTextSize({
  required String text,
  required TextStyle textStyle,
  required BuildContext context,
  TextDirection textDirection = TextDirection.ltr,
}) =>
    (TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: textDirection,
    )..layout())
        .size;
