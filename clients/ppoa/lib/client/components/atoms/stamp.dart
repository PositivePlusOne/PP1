import 'package:flutter/material.dart';
import 'dart:math';

class Stamp extends StatelessWidget {
  const Stamp({
    required this.textString,
    required this.textStyle,
    required this.radiusStart,
    required this.textDirection,
    required this.drawCircles,
    super.key,
  });

  final String textString;
  final TextStyle textStyle;
  final double radiusStart;
  final TextDirection textDirection;
  final bool drawCircles;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedTextPainter(
        textString: textString,
        textStyle: textStyle,
        radiusStart: radiusStart,
        textDirection: textDirection,
        drawCircles: drawCircles,
      ),
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  final String textString;
  final TextStyle textStyle;
  final double radiusStart;
  final Paint textPaint;
  final TextDirection textDirection;
  final bool drawCircles;

  _CurvedTextPainter({
    required this.textDirection,
    required this.textString,
    required this.textStyle,
    required this.radiusStart,
    required this.drawCircles,
  }) : textPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    List<CharacterData> characterDataList = calculateRadialStep(textStyle.letterSpacing ?? 3.0, textString, radiusStart, textDirection, textStyle);

    double radiusWidth = characterDataList[0].characterPainter.size.height;
    double radiusEnd = radiusStart + radiusWidth;

    double rotationalCorrection = characterDataList[0].characterPainter.size.width / (2 * radiusStart);
    double currentAngleRadian = -rotationalCorrection;

    // 2pi R is the circumference, so C=2pir
    // C = 2pr so text space / C is the ratio of the circle
    //
    // double angleRatio = (textSpacing) / (pi * radiusStart * 2);
    // double angleRadianStep = angleRatio * 2 * pi;
    // final step cancles 2 * pi so textSpacing / radius

    for (var i = 0; i < characterDataList.length; i++) {
      canvas.save();
      canvas.translate(sin(currentAngleRadian) * radiusEnd, cos(currentAngleRadian + pi) * radiusEnd);
      canvas.rotate(currentAngleRadian + rotationalCorrection);
      characterDataList[i].characterPainter.paint(canvas, Offset.zero);
      canvas.restore();

      double angleRadianStep = characterDataList[i].angleRadialStep;
      if (textDirection == TextDirection.ltr) {
        currentAngleRadian += angleRadianStep;
      } else {
        currentAngleRadian -= angleRadianStep;
      }
    }

    if (drawCircles) {
      canvas.drawCircle(Offset.zero, radiusStart, textPaint);
      canvas.drawCircle(Offset.zero, radiusEnd, textPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

List<CharacterData> calculateRadialStep(double letterSpacing, String textString, double radius, TextDirection textDirection, TextStyle textStyle) {
  List<CharacterData> characterDataList = [];
  Text text = Text(textString);

  int i = 0;
  TextPainter characterPainter;
  double angleRadialStep = 0;
  for (final char in text.data!.split("")) {
    characterPainter = TextPainter(
      text: TextSpan(text: char, style: textStyle),
      textDirection: textDirection,
    )..layout();
    switch (textString[i]) {
      case "T":
        angleRadialStep = (letterSpacing + (0.9 * characterPainter.size.width)) / radius;
        if (i - 1 >= 0) {
          characterDataList[i - 1].angleRadialStep -= (characterPainter.size.width * 0.1) / radius;
        }
        break;
      default:
        angleRadialStep = (letterSpacing + characterPainter.size.width) / radius;
    }
    characterDataList.add(CharacterData(characterPainter, angleRadialStep));
    i++;
  }

  return characterDataList;
}

class CharacterData {
  final TextPainter characterPainter;
  double angleRadialStep;

  CharacterData(this.characterPainter, this.angleRadialStep);
}
