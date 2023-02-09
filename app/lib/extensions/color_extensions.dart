// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import '../constants/design_constants.dart';

extension ColorStringExtensions on String {
  Color toColorFromHex() {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }

    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ColorExtensions on Color {
  double get brightness {
    final double relativeLuminance = computeLuminance();
    return (relativeLuminance + 0.05) * (relativeLuminance + 0.05);
  }

  String toHex() => '#'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  bool get exceedsBrightnessUpperRestriction => brightness > kBrightnessUpperThreshold;
  bool get exceedsBrightnessLowerRestriction => brightness < kBrightnessLowerThreshold;

  Color complimentTextColor(DesignColorsModel colors) {
    return exceedsBrightnessUpperRestriction ? colors.black : colors.white;
  }
}
