// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import '../dtos/system/design_colors_model.dart';

MarkdownStyleSheet getMarkdownStyleSheet(Color backgroundColor, DesignColorsModel colors, DesignTypographyModel typography) {
  final Color textColor = backgroundColor.complimentTextColor(colors);

  return MarkdownStyleSheet(
    h1: typography.styleHero.copyWith(color: textColor),
    p: typography.styleBody.copyWith(color: textColor),
    a: typography.styleBody.copyWith(
      color: textColor,
      decoration: TextDecoration.underline,
    ),
  );
}
