// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveRecommendedTopics extends ConsumerWidget {
  const PositiveRecommendedTopics({
    required this.tags,
    required this.onTagSelected,
    required this.onSeeMoreSelected,
    super.key,
  });

  final List<Tag> tags;
  final void Function(BuildContext context, Tag tag) onTagSelected;
  final void Function(BuildContext context) onSeeMoreSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));

    final List<Tag> tagsSubset = tags.sublist(0, tags.length > 5 ? 5 : tags.length);
    final bool isSubset = tagsSubset.length < tags.length;

    return SizedBox(
      width: double.infinity,
      height: kSizeRecommendedTopic,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (Tag tag in tagsSubset) ...<Widget>[
            PositiveTileEntryAnimation(
              direction: AxisDirection.right,
              child: PositiveRecomemendedTopic(
                tag: tag,
                typeography: typeography,
                colours: colours,
                onTap: (context) => onTagSelected(context, tag),
              ),
            ),
          ],
          if (isSubset) ...<Widget>[
            PositiveTileEntryAnimation(
              direction: AxisDirection.right,
              child: PositiveViewMoreTopicsTile(
                tag: const Tag(fallback: "View More Topics"),
                typeography: typeography,
                colours: colours,
                onTap: (context) => onSeeMoreSelected(context),
              ),
            ),
          ],
        ].spaceWithHorizontal(kPaddingSmall),
      ),
    );
  }
}

class PositiveViewMoreTopicsTile extends ConsumerWidget {
  const PositiveViewMoreTopicsTile({
    required this.tag,
    required this.typeography,
    required this.colours,
    required this.onTap,
    super.key,
  });

  final Tag tag;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;

  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveTapBehaviour(
      onTap: onTap,
      child: Container(
        width: kSizeRecommendedTopic,
        height: kSizeRecommendedTopic,
        padding: const EdgeInsets.all(kPaddingSmallMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Icon(
                UniconsLine.angle_right,
                color: colours.black,
                size: kIconMedium,
              ),
            ),
            const SizedBox(height: kPaddingExtraSmall),
            Text(
              tag.topic?.fallback ?? tag.fallback,
              style: typeography.styleTopic,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class PositiveRecomemendedTopic extends ConsumerWidget {
  const PositiveRecomemendedTopic({
    required this.tag,
    required this.typeography,
    required this.colours,
    required this.onTap,
    super.key,
  });

  final Tag tag;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;

  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveTapBehaviour(
      onTap: onTap,
      child: Container(
        width: kSizeRecommendedTopic,
        height: kSizeRecommendedTopic,
        padding: const EdgeInsets.all(kPaddingSmallMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          color: colours.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                "#",
                style: typeography.styleTopic.copyWith(color: colours.colorGray4),
              ),
            ),
            const SizedBox(height: kPaddingExtraSmall),
            Text(
              tag.topic?.fallback ?? tag.fallback,
              style: typeography.styleTopic,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
