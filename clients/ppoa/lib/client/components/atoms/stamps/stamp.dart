// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/resources/resources.dart';

class Stamp extends StatefulWidget {
  const Stamp({
    required this.textString,
    required this.textStyle,
    required this.radius,
    required this.textDirection,
    required this.drawCircles,
    required this.startingAngle,
    required this.imageSize,
    required this.svgPath,
    required this.strokeWidth,
    required this.circleColour,
    required this.animate,
    this.radialPadding = 0.0,
    this.alignment = Alignment.center,
    this.fillColour = Colors.transparent,
    super.key,
  });

  final String? textString;
  final TextStyle textStyle;
  final double radius;
  final TextDirection textDirection;
  final bool drawCircles;
  final double startingAngle;
  final double imageSize;
  final String svgPath;
  final double strokeWidth;
  final Alignment alignment;
  final Color circleColour;
  final double radialPadding;
  final bool animate;

  final Color fillColour;

  factory Stamp.onePlus({
    double size = 200,
    double animationValue = 0.0,
    required DesignSystemBrand branding,
    Alignment? alignment,
    bool animate = false,
    String text = 'POSITIVE\nPOSITIVE',
    Color? color,
    Color? textColor,
    double startingAngle = 0.0,
  }) {
    return Stamp(
      textString: text,
      textStyle: TextStyle(
        color: textColor ?? branding.colors.black,
        fontSize: size / 5.5,
        letterSpacing: size / 100,
        fontFamily: "AlbertSans",
        fontWeight: FontWeight.w800,
      ),
      radius: size / 2,
      textDirection: TextDirection.ltr,
      drawCircles: true,
      startingAngle: animationValue + startingAngle,
      strokeWidth: size / 25,
      imageSize: size,
      svgPath: SvgImages.stampPlusOne,
      alignment: alignment ?? Alignment.center,
      circleColour: color ?? branding.colors.black,
      radialPadding: size / 90,
      animate: animate,
    );
  }

  factory Stamp.fist({
    double size = 200,
    double animationValue = 0.0,
    required DesignSystemBrand branding,
    Alignment? alignment,
    bool animate = false,
    String text = 'I\'M A LOVER\nAND A FIGHTER',
    Color? textColor,
    Color? color,
    double startingAngle = 0.0,
  }) {
    return Stamp(
      textString: text,
      textStyle: TextStyle(
        color: textColor ?? branding.colors.black,
        fontSize: size / 7.0,
        letterSpacing: size / 300,
        fontFamily: "AlbertSans",
        fontWeight: FontWeight.w800,
      ),
      radius: size / 2,
      textDirection: TextDirection.ltr,
      drawCircles: false,
      startingAngle: animationValue + startingAngle,
      strokeWidth: size / 25,
      imageSize: size * 0.85,
      svgPath: SvgImages.stampFist,
      alignment: alignment ?? Alignment.center,
      circleColour: color ?? branding.colors.black,
      animate: animate,
    );
  }

  factory Stamp.victory({
    double size = 200,
    double animationValue = 0.0,
    required DesignSystemBrand branding,
    Alignment? alignment,
    bool animate = false,
    String text = 'NO DRAMA\nJUST LOVE',
    Color? textColor,
    Color? color,
    double startingAngle = 0.0,
  }) {
    return Stamp(
      textString: text,
      textStyle: TextStyle(
        color: textColor ?? branding.colors.black,
        fontSize: size / 6.0,
        letterSpacing: size / 100,
        fontFamily: "AlbertSans",
        fontWeight: FontWeight.w800,
      ),
      radius: size / 2,
      textDirection: TextDirection.ltr,
      drawCircles: false,
      startingAngle: animationValue + startingAngle,
      strokeWidth: size / 25,
      imageSize: size * 0.85,
      svgPath: SvgImages.stampVictoryHand,
      alignment: alignment ?? Alignment.center,
      circleColour: color ?? branding.colors.black,
      animate: animate,
    );
  }

  factory Stamp.smile({
    double size = 200,
    double animationValue = 0.0,
    required DesignSystemBrand branding,
    Alignment? alignment,
    Color? fillColour,
    double startingAngle = 0.0,
  }) {
    return Stamp(
      textString: null,
      textStyle: TextStyle(
        color: branding.colors.black,
        fontSize: 0.0,
        letterSpacing: 0.0,
        fontFamily: "AlbertSans",
        fontWeight: FontWeight.w800,
      ),
      radius: size / 2,
      textDirection: TextDirection.ltr,
      drawCircles: false,
      startingAngle: animationValue + startingAngle,
      strokeWidth: 0.0,
      imageSize: size * 1.0,
      svgPath: SvgImages.stampSmile,
      alignment: alignment ?? Alignment.center,
      circleColour: branding.colors.black,
      fillColour: fillColour ?? branding.colors.teal,
      animate: false,
    );
  }

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    //TODO: standarise duration
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.repeat();
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double halfStrokeWidth = widget.strokeWidth / 2;
    final double radiusWidthAdjustment = widget.radius - halfStrokeWidth;

    return Align(
      alignment: widget.alignment,
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
        child: CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: (widget.textString != null)
              ? _CurvedTextPainter(
                  textString: widget.textString!,
                  textStyle: widget.textStyle,
                  radius: radiusWidthAdjustment,
                  textDirection: widget.textDirection,
                  drawCircles: widget.drawCircles,
                  startingAngle: widget.animate ? widget.startingAngle + animation.value : widget.startingAngle,
                  strokeWidth: widget.strokeWidth,
                  circleColour: widget.circleColour,
                  radialPadding: widget.radialPadding,
                )
              : _SmileBadgePainter(
                  badgeColour: widget.fillColour,
                ),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: widget.imageSize,
              width: widget.imageSize,
              child: SvgPicture.asset(
                widget.svgPath,
                fit: BoxFit.contain,
                color: widget.circleColour,
                alignment: Alignment.center,
              ),
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
  final Paint circlePaint;
  final TextDirection textDirection;
  final bool drawCircles;
  final double startingAngle;
  final double strokeWidth;
  final Color circleColour;
  final double radialPadding;

  _CurvedTextPainter({
    required this.startingAngle,
    required this.textDirection,
    required this.textString,
    required this.textStyle,
    required this.radius,
    required this.drawCircles,
    required this.strokeWidth,
    required this.circleColour,
    required this.radialPadding,
  }) : circlePaint = Paint()
          ..color = circleColour
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double textRadius = radius - radialPadding;
    final CharacterData characterData = calculateRadialStep(textStyle.letterSpacing ?? 3.0, textString, textRadius, textDirection, textStyle);
    final double textHeight = characterData.characterPainter[0].size.height;
    final double internalRadius = radius - textHeight - radialPadding * 2;
    final double halfStrokeWidth = strokeWidth / 2;
    canvas.translate(radius + halfStrokeWidth, radius + halfStrokeWidth);

    if (internalRadius <= 0.0) {
      throw Exception("Internal radius is greater than given radial section");
    }

    if (characterData.totalAngle > pi * 2) {
      throw Exception("Text overflow in radial text generator");
    }

    double currentAngleRadian = startingAngle * 2 * pi;
    double newlineTextSpace = (2 * pi - characterData.totalAngle) / characterData.lines;

    //* 2pi R is the circumference, so C=2pir
    //* C = 2pr so text space / C is the ratio of the circle
    //*
    //* double angleRatio = (textSpacing) / (pi * radiusStart * 2);
    //* double angleRadianStep = angleRatio * 2 * pi;
    //* final step cancles 2 * pi so textSpacing / radius

    for (var i = 0; i < characterData.angleRadialStep.length; i++) {
      if (characterData.angleRadialStep[i] != 0.0) {
        canvas.save();
        canvas.translate(sin(currentAngleRadian) * textRadius, cos(currentAngleRadian + pi) * textRadius);
        double rotationalCorrection = characterData.characterPainter[i].size.width / (4 * internalRadius);
        canvas.rotate(currentAngleRadian + rotationalCorrection);
        characterData.characterPainter[i].paint(canvas, Offset.zero);
        canvas.restore();

        if (textDirection == TextDirection.ltr) {
          currentAngleRadian += characterData.angleRadialStep[i];
        } else {
          currentAngleRadian -= characterData.angleRadialStep[i];
        }
      } else {
        if (textDirection == TextDirection.ltr) {
          currentAngleRadian += newlineTextSpace;
        } else {
          currentAngleRadian -= newlineTextSpace;
        }
      }
    }

    if (drawCircles) {
      canvas.drawCircle(Offset.zero, internalRadius, circlePaint);
      canvas.drawCircle(Offset.zero, radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedTextPainter oldDelegate) {
    return oldDelegate.startingAngle != startingAngle;
  }
}

class _SmileBadgePainter extends CustomPainter {
  final Paint badgePaint;
  final Color badgeColour;

  _SmileBadgePainter({
    required this.badgeColour,
  }) : badgePaint = Paint()
          ..color = badgeColour
          ..style = PaintingStyle.fill
          ..strokeWidth = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(size.width * 0.04938135, size.height * 0.04915202)
      ..lineTo(size.width * 0.04960629, size.height * 0.4901742)
      ..cubicTo(size.width * 0.04960629, size.height * 0.7379539, size.width * 0.2517438, size.height * 0.9396124, size.width * 0.5001124, size.height * 0.9396124)
      ..cubicTo(size.width * 0.7484809, size.height * 0.9396124, size.width * 0.9506191, size.height * 0.7379539, size.width * 0.9506191, size.height * 0.4901742)
      ..lineTo(size.width * 0.9508438, size.height * 0.04915202)
      ..lineTo(size.width * 0.04938135, size.height * 0.04915202)
      ..close();
    canvas.drawPath(path, badgePaint);
  }

  @override
  bool shouldRepaint(covariant _SmileBadgePainter oldDelegate) {
    return false;
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

    final double radius = outerRadius - (characterPainter.height / 2);

    if (textString[i] == '\n') {
      angleRadialStep = 0.0;
      characterData.lines++;
    } else {
      angleRadialStep = radialStepCalculation(characterPainter, letterSpacing, radius, i, characterData);
    }

    characterData.characterPainter.add(characterPainter);
    characterData.angleRadialStep.add(angleRadialStep);
    characterData.totalAngle += angleRadialStep;
    i++;
  }
  return characterData;
}

double radialStepCalculation(TextPainter characterPainter, double letterSpacing, double radius, int i, CharacterData characterData) {
  return (letterSpacing + (characterPainter.size.width)) / radius;
}

class CharacterData {
  double totalAngle = 0.0;
  double lines = 1;
  final List<TextPainter> characterPainter = [];
  final List<double> angleRadialStep = [];
}
