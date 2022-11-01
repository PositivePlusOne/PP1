import 'package:flutter/material.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

import '../../client/constants/ppo_design_constants.dart';

extension BrandExtensions on DesignSystemBrand {}

extension BrandDoubleExtensions on double {
  Widget get asVerticalWidget => SizedBox(height: this);
  Widget get asHorizontalWidget => SizedBox(width: this);
}

extension BrandStringExtensions on String {
  Color toColorFromHex() {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }

    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension BrandColorExtensions on Color {
  double get brightness {
    final double relativeLuminance = computeLuminance();
    return (relativeLuminance + 0.05) * (relativeLuminance + 0.05);
  }

  String toHex() => '#'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  bool get exceedsBrightnessRestriction => brightness > ppoBrightnessThreshold;

  Color complimentTextColor(DesignSystemBrand brand) {
    return exceedsBrightnessRestriction ? brand.colorBlack.toColorFromHex() : brand.colorWhite.toColorFromHex();
  }
}
