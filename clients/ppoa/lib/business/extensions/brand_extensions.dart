// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';

// Project imports:
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import '../../client/constants/ppo_design_constants.dart';

extension BrandExtensions on DesignSystemBrand {
  MarkdownStyleSheet getMarkdownStyleSheet(Color backgroundColor) {
    final Color textColor = backgroundColor.complimentTextColor(this);

    return MarkdownStyleSheet(
      h1: typography.styleHero.copyWith(color: textColor),
      p: typography.styleBody.copyWith(color: textColor),
      a: typography.styleBody.copyWith(
        color: textColor,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

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

  bool get exceedsBrightnessUpperRestriction => brightness > kBrightnessUpperThreshold;
  bool get exceedsBrightnessLowerRestriction => brightness < kBrightnessLowerThreshold;

  Color complimentTextColor(DesignSystemBrand brand) {
    return exceedsBrightnessUpperRestriction ? brand.colors.black : brand.colors.white;
  }
}
