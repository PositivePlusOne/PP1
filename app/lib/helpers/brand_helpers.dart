// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/mentions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/tag_extensions.dart';
import 'package:app/helpers/markdown_truncator.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration_model.dart';
import '../dtos/system/design_colors_model.dart';
import '../resources/resources.dart';
import '../widgets/molecules/scaffolds/positive_scaffold_decoration.dart';

MarkdownWidget buildMarkdownWidgetFromBody(
  String str, {
  Brightness brightness = Brightness.light,
  List<Tag> tags = const [],
  EdgeInsets lineMargin = const EdgeInsets.symmetric(vertical: kPaddingExtraSmall),
  void Function(String link)? onTapLink,
  bool boldHandles = true,
  List<Mention> mentions = const [],
  bool squashParagraphs = false,
  int maxLength = -1,
}) {
  //! Add the tags to the start of the markdown as bolded text
  String markdown = str;
  final Map<String, String> mentionsIdMap = {};

  for (final Mention mention in mentions) {
    mentionsIdMap[mention.label] = mention.foreignKey;
  }

  //? bold all user handles
  //! This is useful as if you attempt to mention someone who has blocked you
  //! The mention will not be added to the list of mentions
  //! So in this case, we want to bold the handle so the user knows it is a handle, despite no mention being persisted
  if (boldHandles) {
    markdown = markdown.boldHandlesAndLink(knownIdMap: mentionsIdMap);
  }

  if (squashParagraphs) {
    markdown = markdown.squashParagraphs();
  }

  if (maxLength > 0) {
    markdown = MarkdownTruncator.formatText(markdown, limit: maxLength, ellipsis: true);
  }

  // Add each tag as a bold markdown hashtag with a link to the tag (schema pp1://)
  final StringBuffer tagBuffer = StringBuffer();
  for (final Tag tag in tags) {
    final bool isReserved = TagHelpers.isReserved(tag.key);
    if (isReserved) {
      continue;
    }

    tagBuffer.write('[#${tag.key}](${tag.buildTagLink()}) ');
  }

  // Add the tags to the start of the markdown as bolded text
  if (tagBuffer.isNotEmpty) {
    markdown = '$markdown\n\n${tagBuffer.toString()}';
  }

  return MarkdownWidget(
    data: markdown,
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    selectable: false,
    config: MarkdownConfig(
      configs: buildMarkdownWidgetConfig(onTapLink: onTapLink, brightness: brightness),
    ),
  );
}

void _onInternalLinkedTapped(void Function(String link)? onTapLink, String link) {
  final Logger logger = providerContainer.read(loggerProvider);
  logger.d('Link tapped: $link');

  if (onTapLink != null) {
    onTapLink(link);
  } else {
    logger.d('No onTapLink function provided, attempting to launch URL: $link');
    link.attemptToLaunchURL();
  }
}

List<WidgetConfig> buildMarkdownWidgetConfig({void Function(String link)? onTapLink, Brightness brightness = Brightness.light}) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

  final Color textColor = brightness == Brightness.light ? colors.black : colors.white;

  return [
    PreConfig(
      textStyle: typography.styleBody.copyWith(color: textColor),
      decoration: BoxDecoration(
        color: colors.colorGray1,
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    H1Config(style: typography.styleHeroMedium.copyWith(color: textColor)),
    H2Config(style: typography.styleHeroSmall.copyWith(color: textColor)),
    H3Config(style: typography.styleTitle.copyWith(color: textColor)),
    H4Config(style: typography.styleTitleTwo.copyWith(color: textColor)),
    H5Config(style: typography.styleSubtitleBold.copyWith(color: textColor)),
    H6Config(style: typography.styleSubtextBold.copyWith(color: textColor)),
    PConfig(textStyle: typography.styleBody.copyWith(color: textColor)),
    LinkConfig(
      style: typography.styleBold.copyWith(color: colors.linkBlue),
      onTap: (link) => _onInternalLinkedTapped(onTapLink, link),
    ),
    CodeConfig(style: typography.styleSubtitle.copyWith(color: textColor, fontFamily: 'AlbertSans')),
    BlockquoteConfig(sideColor: colors.purple, textColor: textColor),
    TableConfig(bodyStyle: typography.styleBody.copyWith(color: textColor)),
    ListConfig(
      marginLeft: kPaddingMedium,
      marker: (isOrdered, depth, index) {
        return Container(
          margin: const EdgeInsets.only(left: kPaddingSmall),
          child: Text(
            isOrdered ? '${index + 1}.' : '•',
            style: TextStyle(color: textColor),
          ),
        );
      },
    ),
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

List<PositiveScaffoldDecoration> buildType4ScaffoldDecorations(DesignColorsModel colors) {
  return <PositiveScaffoldDecorationModel>[
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationStampCertified,
      alignment: Alignment.topLeft,
      color: colors.teal,
      scale: 1.4,
      offsetX: -25.0,
      offsetY: 0,
      rotationDegrees: 0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationFace,
      alignment: Alignment.topRight,
      color: colors.pink,
      scale: 1,
      offsetX: 0.0,
      offsetY: -50.0,
      rotationDegrees: 20.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationEye,
      alignment: Alignment.bottomLeft,
      color: colors.purple,
      scale: 0.9,
      offsetX: -50.0,
      offsetY: -30.0,
      rotationDegrees: -10.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationArrowHollowRight,
      alignment: Alignment.bottomRight,
      color: colors.yellow,
      scale: 1,
      offsetX: 0.0,
      offsetY: -110.0,
      rotationDegrees: 20.0,
    ),
  ].map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList();
}

List<PositiveScaffoldDecoration> buildType5ScaffoldDecorations(DesignColorsModel colors) {
  return <PositiveScaffoldDecorationModel>[
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationStar,
      alignment: Alignment.bottomCenter,
      color: colors.purple,
      scale: 1,
      offsetX: 0,
      offsetY: 70,
      rotationDegrees: -0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationRings,
      alignment: Alignment.bottomLeft,
      color: colors.teal,
      scale: 1,
      offsetX: -100,
      offsetY: 0,
      rotationDegrees: -10.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationArrowRight,
      alignment: Alignment.topLeft,
      color: colors.yellow,
      scale: 1,
      offsetX: -80,
      offsetY: 0,
      rotationDegrees: -30.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationFlower,
      alignment: Alignment.center,
      color: colors.black,
      scale: 1,
      offsetX: 0,
      offsetY: 0,
      rotationDegrees: 0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationGlobe,
      alignment: Alignment.topRight,
      color: colors.pink,
      scale: 1.1,
      offsetX: 60,
      offsetY: 20,
      rotationDegrees: 0.0,
    ),
    PositiveScaffoldDecorationModel(
      asset: SvgImages.decorationEye,
      alignment: Alignment.bottomRight,
      color: colors.green,
      scale: 0.9,
      offsetX: 110,
      offsetY: -30,
      rotationDegrees: 40.0,
    ),
  ].map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList();
}
