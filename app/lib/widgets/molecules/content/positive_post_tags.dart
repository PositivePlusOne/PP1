// Flutter imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';

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
    final CacheController cacheController = ref.watch(cacheControllerProvider.notifier);
    final Locale locale = Localizations.localeOf(context);
    final Iterable<Tag> tagInstances = tags.map((element) => cacheController.getFromCache(element)).whereType<Tag>().where((element) => element.fallback.isNotEmpty);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (Tag tag in tagInstances)
            PositivePostTag(
              text: TagHelpers.getTagLocalizedName(tag, locale),
              typeography: typeography,
              colours: colours,
            ),
        ].addSeparatorsToWidgetList(separator: const SizedBox(width: kPaddingSmall)),
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
