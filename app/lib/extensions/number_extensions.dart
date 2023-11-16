// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

extension DoubleExtensions on double {
  double get degreeToRadian {
    return this * pi / 180;
  }

  double get radianToDegree {
    return this * 180 / pi;
  }

  SizedBox get asVerticalBox => SizedBox(height: this);
  SizedBox get asHorizontalBox => SizedBox(width: this);
}
