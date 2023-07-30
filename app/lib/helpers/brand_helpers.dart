// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration_model.dart';
import '../dtos/system/design_colors_model.dart';
import '../resources/resources.dart';
import '../widgets/molecules/scaffolds/positive_scaffold_decoration.dart';

MarkdownStyleSheet getMarkdownStyleSheet(Color backgroundColor, DesignColorsModel colors, DesignTypographyModel typography) {
  final Color textColor = backgroundColor.complimentTextColor;

  return MarkdownStyleSheet(
    blockSpacing: kPaddingMedium,
    h1: typography.styleSuperSize.copyWith(color: textColor),
    p: typography.styleBody.copyWith(color: textColor),
    a: typography.styleBody.copyWith(
      color: textColor,
      decoration: TextDecoration.underline,
    ),
  );
}

List<PositiveScaffoldDecoration> buildType1ScaffoldDecorations(DesignColorsModel colors) {
  return <PositiveScaffoldDecorationModel>[
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationStar,
      alignment: Alignment.bottomRight,
      color: colors.purple,
      scale: 1.5,
      offsetX: 50.0,
      offsetY: 50.0,
      rotationDegrees: 0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationArrowRight,
      alignment: Alignment.topRight,
      color: colors.yellow,
      scale: 1.2,
      offsetX: 50.0,
      offsetY: 50.0,
      rotationDegrees: -15.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationRings,
      alignment: Alignment.bottomLeft,
      color: colors.teal,
      scale: 1.5,
      offsetX: -50.0,
      offsetY: 25.0,
      rotationDegrees: -15.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationEye,
      alignment: Alignment.topLeft,
      color: colors.green,
      scale: 1.1,
      offsetX: -15.0,
      offsetY: -0.0,
      rotationDegrees: 15.0,
    ),
  ].map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList();
}

List<PositiveScaffoldDecoration> buildType2ScaffoldDecorations(DesignColorsModel colors) {
  return <PositiveScaffoldDecorationModel>[
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationGlobe,
      alignment: Alignment.bottomRight,
      color: colors.green,
      scale: 1.6,
      offsetX: 25.0,
      offsetY: 25.0,
      rotationDegrees: -0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationStampStar,
      alignment: Alignment.bottomLeft,
      color: colors.purple,
      scale: 1.2,
      offsetX: -35.0,
      offsetY: 50.0,
      rotationDegrees: -15.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationEye,
      alignment: Alignment.topCenter,
      color: colors.pink,
      scale: 0.95,
      offsetX: -15.0,
      offsetY: 35.0,
      rotationDegrees: -15.0,
    ),
  ].map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList();
}

List<PositiveScaffoldDecoration> buildType3ScaffoldDecorations(DesignColorsModel colors) {
  return <PositiveScaffoldDecorationModel>[
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationGlobe,
      alignment: Alignment.bottomRight,
      color: colors.green,
      scale: 1.6,
      offsetX: 25.0,
      offsetY: 25.0,
      rotationDegrees: -0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationStampStar,
      alignment: Alignment.bottomLeft,
      color: colors.purple,
      scale: 1.2,
      offsetX: -35.0,
      offsetY: 50.0,
      rotationDegrees: -15.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationFace,
      alignment: Alignment.topCenter,
      color: colors.pink,
      scale: 0.95,
      offsetX: -15.0,
      offsetY: 35.0,
      rotationDegrees: 15.0,
    ),
  ].map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList();
}
