// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import '../constants/design_constants.dart';
import '../main.dart';
import '../providers/system/design_controller.dart';

extension ColorStringExtensions on String {
  Color toColorFromHex() {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }

    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color toSafeColorFromHex({
    Color defaultColor = Colors.black,
  }) {
    try {
      return toColorFromHex();
    } catch (e) {
      return defaultColor;
    }
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

  Brightness get computedSystemBrightness => exceedsBrightnessUpperRestriction ? Brightness.light : Brightness.dark;

  SystemUiOverlayStyle get systemUiOverlayStyle => SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: computedSystemBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: computedSystemBrightness,
        statusBarBrightness: computedSystemBrightness,
        systemNavigationBarDividerColor: Colors.transparent,
      );

  Color getNextSelectableProfileColor() {
    final List<Color> colors = DesignColorsModel.selectableProfileColors;
    int currentIndex = colors.indexOf(this);
    if (currentIndex == -1) {
      currentIndex = 0;
    }

    final int nextIndex = (currentIndex + 1) % colors.length;
    return colors[nextIndex];
  }

  Color get complimentTextColor {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    return exceedsBrightnessUpperRestriction ? colors.black : colors.white;
  }
}
