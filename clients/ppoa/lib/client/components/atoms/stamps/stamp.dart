import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppoa/resources/resources.dart';

class Stamp extends StatelessWidget {
  const Stamp({
    required this.textString,
    required this.textStyle,
    required this.radius,
    required this.textDirection,
    required this.drawCircles,
    required this.startingAngle,
    required this.repeatText,
    required this.imageSize,
    required this.svgPath,
    super.key,
  });

  final String textString;
  final TextStyle textStyle;
  final double radius;
  final TextDirection textDirection;
  final bool drawCircles;
  final double startingAngle;
  final int repeatText;
  final double imageSize;
  final String svgPath;

  factory Stamp.onePlus({double size = 200, double animationValue = 0.0}) {
    return Stamp(
      textString: "POSITIVE",
      textStyle: TextStyle(color: Colors.black, fontSize: size / 6, letterSpacing: 0, fontFamily: "AlbertSans", fontWeight: FontWeight.w900),
      radius: size / 2,
      textDirection: TextDirection.ltr,
      drawCircles: true,
      startingAngle: animationValue,
      repeatText: 2,
      imageSize: size,
      svgPath: SvgImages.stampPlusOne,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        size: Size(radius * 2, radius * 2),
        painter: _CurvedTextPainter(
          textString: textString,
          textStyle: textStyle,
          radius: radius,
          textDirection: textDirection,
          drawCircles: drawCircles,
          startingAngle: startingAngle,
          repeatText: repeatText,
        ),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: imageSize,
            width: imageSize,
            child: SvgPicture.asset(
              svgPath,
              // fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  final String textString;
  final TextStyle textStyle;
  final double radius;
  final Paint textPaint;
  final TextDirection textDirection;
  final bool drawCircles;
  final double startingAngle;
  final int repeatText;

  _CurvedTextPainter({
    required this.repeatText,
    required this.startingAngle,
    required this.textDirection,
    required this.textString,
    required this.textStyle,
    required this.radius,
    required this.drawCircles,
  }) : textPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final CharacterData characterData = calculateRadialStep(textStyle.letterSpacing ?? 3.0, textString, radius, textDirection, textStyle);
    final double textHeight = characterData.characterPainter[0].size.height;
    final double internalRadius = radius - textHeight;
    canvas.translate(radius, radius);

    if (radius - internalRadius > textHeight) {
      throw Exception("Text height is greater than given radial section");
    }
    if (characterData.totalAngle > pi * 2 / repeatText) {
      throw Exception("Text overflow in radial text generator");
    }

    double rotationalCorrection = characterData.characterPainter[0].size.width / (2 * internalRadius);
    double currentAngleRadian = startingAngle * 2 * pi;
    double repeatTextSpace = (2 * pi - (characterData.totalAngle * repeatText)) / repeatText;

    //* 2pi R is the circumference, so C=2pir
    //* C = 2pr so text space / C is the ratio of the circle
    //*
    //* double angleRatio = (textSpacing) / (pi * radiusStart * 2);
    //* double angleRadianStep = angleRatio * 2 * pi;
    //* final step cancles 2 * pi so textSpacing / radius

    //TODO: check for overflow mathmatically
    //TODO: missaligned T I etc due to subtraction of angle

    for (var j = 0; j < repeatText; j++) {
      for (var i = 0; i < characterData.angleRadialStep.length; i++) {
        canvas.save();
        canvas.translate(sin(currentAngleRadian) * radius, cos(currentAngleRadian + pi) * radius);
        canvas.rotate(currentAngleRadian + rotationalCorrection);
        characterData.characterPainter[i].paint(canvas, Offset.zero);
        canvas.restore();

        if (textDirection == TextDirection.ltr) {
          currentAngleRadian += characterData.angleRadialStep[i];
        } else {
          currentAngleRadian -= characterData.angleRadialStep[i];
        }
      }
      if (textDirection == TextDirection.ltr) {
        currentAngleRadian += repeatTextSpace;
      } else {
        currentAngleRadian -= repeatTextSpace;
      }
    }

    if (drawCircles) {
      canvas.drawCircle(Offset.zero, internalRadius, textPaint);
      canvas.drawCircle(Offset.zero, radius, textPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

CharacterData calculateRadialStep(double letterSpacing, String textString, double outerRadius, TextDirection textDirection, TextStyle textStyle) {
  CharacterData characterData = CharacterData();
  Text text = Text(textString);

  int i = 0;
  TextPainter characterPainter;
  double angleRadialStep = 0;
  for (final char in text.data!.split("")) {
    characterPainter = TextPainter(
      text: TextSpan(text: char, style: textStyle),
      textDirection: textDirection,
    )..layout();
    double radius = outerRadius - characterPainter.height;
    switch (textString[i]) {
      case "T":
        angleRadialStep = radialStepCalculation(0.1, characterPainter, letterSpacing, radius, i, characterData);
        break;
      case "'":
        angleRadialStep = radialStepCalculation(0.1, characterPainter, letterSpacing, radius, i, characterData);
        break;
      case "I":
        angleRadialStep = radialStepCalculation(0.1, characterPainter, letterSpacing, radius, i, characterData);
        break;
      case "i":
        angleRadialStep = radialStepCalculation(0.1, characterPainter, letterSpacing, radius, i, characterData);
        break;
      default:
        angleRadialStep = radialStepCalculation(0.0, characterPainter, letterSpacing, radius, i, characterData);
    }
    characterData.characterPainter.add(characterPainter);
    characterData.angleRadialStep.add(angleRadialStep);
    characterData.totalAngle += angleRadialStep;
    i++;
  }

  return characterData;
}

double radialStepCalculation(double letterMultiplier, TextPainter characterPainter, double letterSpacing, double radius, int i, CharacterData characterData) {
  if (i - 1 >= 0) {
    characterData.angleRadialStep[i - 1] -= (characterPainter.size.width * letterMultiplier) / radius;
  }
  return (letterSpacing + ((1.0 - letterMultiplier) * characterPainter.size.width)) / radius;
}

class CharacterData {
  double totalAngle = 0.0;
  final List<TextPainter> characterPainter = [];
  final List<double> angleRadialStep = [];
}
