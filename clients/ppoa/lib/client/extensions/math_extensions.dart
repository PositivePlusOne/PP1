import 'dart:math';

extension MathDoubleExtensions on double {
  double get degreeToRadian {
    return this * pi / 180;
  }

  double get radianToDegree {
    return this * 180 / pi;
  }
}
