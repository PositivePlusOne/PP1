// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration_model.dart';
import '../dtos/system/design_colors_model.dart';
import '../resources/resources.dart';
import '../widgets/molecules/scaffolds/positive_scaffold_decoration.dart';

MarkdownWidget buildMarkdownWidgetFromBody(String str, {void Function(String link)? onTapLink}) {
  return MarkdownWidget(
    data: str,
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    config: MarkdownConfig(configs: buildMmarkdownWidgetConfig(onTapLink: onTapLink)),
    markdownGeneratorConfig: MarkdownGeneratorConfig(
      linesMargin: const EdgeInsets.symmetric(vertical: kPaddingExtraSmall),
    ),
  );
}

List<WidgetConfig> buildMmarkdownWidgetConfig({void Function(String link)? onTapLink}) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

  return [
    PreConfig(textStyle: typography.styleBody.copyWith(color: colors.black)),
    H1Config(style: typography.styleHeroMedium.copyWith(color: colors.black)),
    H2Config(style: typography.styleHeroSmall.copyWith(color: colors.black)),
    H3Config(style: typography.styleTitle.copyWith(color: colors.black)),
    H4Config(style: typography.styleTitleTwo.copyWith(color: colors.black)),
    H5Config(style: typography.styleSubtitleBold.copyWith(color: colors.black)),
    H6Config(style: typography.styleSubtextBold.copyWith(color: colors.black)),
    PConfig(textStyle: typography.styleBody.copyWith(color: colors.black)),
    LinkConfig(
      style: typography.styleBody.copyWith(
        color: colors.linkBlue,
        decoration: TextDecoration.underline,
      ),
      onTap: (link) {
        if (onTapLink != null) {
          onTapLink(link);
        } else {
          link.attemptToLaunchURL();
        }
      },
    ),
    CodeConfig(style: typography.styleSubtitle.copyWith(color: colors.black, fontFamily: 'AlbertSans')),
    BlockquoteConfig(sideColor: colors.purple, textColor: colors.black),
    TableConfig(bodyStyle: typography.styleBody.copyWith(color: colors.black)),
    const ListConfig(marginLeft: kPaddingMedium),
    ImgConfig(
      builder: (url, attributes) => PositiveMediaImage(
        media: Media.fromImageUrl(url),
      ),
    ),
  ];
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
