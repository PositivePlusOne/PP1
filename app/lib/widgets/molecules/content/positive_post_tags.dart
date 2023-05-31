import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dtos/system/design_typography_model.dart';
import '../../../helpers/list_helpers.dart';

class PositivePostHorizontalTags extends ConsumerWidget {
  const PositivePostHorizontalTags({
    required this.tags,
    required this.typeography,
    required this.colours,
    super.key,
  });

  final List<String> tags;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...addSeparatorsToWidgetList(
            list: [
              for (String tag in tags)
                PositivePostTag(
                  text: tag,
                  typeography: typeography,
                  colours: colours,
                ),
            ],
            separator: SizedBox(
              width: kPaddingSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class PositivePostTag extends ConsumerWidget {
  const PositivePostTag({
    required this.text,
    required this.typeography,
    required this.colours,
    super.key,
  });

  final String text;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        color: colours.white,
      ),
      child: Text(
        text,
        style: typeography.styleSubtextBold.copyWith(color: colours.colorGray7),
      ),
    );
  }
}

class PositivePostIconTag extends ConsumerWidget {
  const PositivePostIconTag({
    required this.text,
    required this.typeography,
    required this.colours,
    required this.forwardIcon,
    super.key,
  });

  final String text;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;
  final IconData forwardIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        color: colours.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            forwardIcon,
            size: kIconExtraSmall,
            color: colours.colorGray7,
          ),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            text,
            style: typeography.styleSubtextBold.copyWith(color: colours.colorGray7),
          ),
        ],
      ),
    );
  }
}
