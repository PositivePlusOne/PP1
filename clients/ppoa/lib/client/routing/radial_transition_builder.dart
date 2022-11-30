import 'dart:math';

import 'package:flutter/material.dart';

class RadialTransitionsBuilder {
  const RadialTransitionsBuilder._();

  static const RouteTransitionsBuilder radialTransition = _RadialTransitionBuilder;
  static const FractionalOffset offset = FractionalOffset(0.2, 0.7);
  static const Duration duration = Duration(milliseconds: 500);

  static Widget _RadialTransitionBuilder(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
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

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      child: child,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return RadialGradient(
              radius: animation.value * radialMultiplier,
              colors: const [Colors.white, Colors.white, Colors.transparent],
              stops: const [0.0, 1.0, 1.0],
              center: offset,
            ).createShader(rect);
          },
          child: child,
        );
      },
    );
  }
}
