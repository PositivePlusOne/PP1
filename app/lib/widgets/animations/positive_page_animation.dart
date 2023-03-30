// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';

class PositivePageAnimation {
  const PositivePageAnimation._();

  static const RouteTransitionsBuilder radialTransition = radialTransitionBuilder;
  static const FractionalOffset offset = FractionalOffset(0.5, 0.85);

  static const int durationMillis = 1000;
  static const Duration duration = Duration(milliseconds: durationMillis);

  static Widget radialTransitionBuilder(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;

    double halfSize;
    double widthFromOffset;
    double heightFromOffset;

    if (width <= height) {
      halfSize = width / 2;
    } else {
      halfSize = height / 2;
    }

    if (offset.dx <= 0.5) {
      widthFromOffset = (1.0 - offset.dx) * width;
    } else {
      widthFromOffset = offset.dx * width;
    }

    if (offset.dy <= 0.5) {
      heightFromOffset = (1.0 - offset.dy) * height;
    } else {
      heightFromOffset = offset.dy * height;
    }

    double radiusValue = sqrt((widthFromOffset * widthFromOffset) + (heightFromOffset * heightFromOffset));

    double radialMultiplier = radiusValue / halfSize;

    const double fadeLength = 1.00;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      child: child,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return RadialGradient(
              radius: animation.value * radialMultiplier / fadeLength,
              colors: [colors.white, colors.white, colors.white.withOpacity(0.0)],
              stops: const [0.0, fadeLength, 1.0],
              center: offset,
            ).createShader(rect);
          },
          child: child,
        );
      },
    );
  }
}
