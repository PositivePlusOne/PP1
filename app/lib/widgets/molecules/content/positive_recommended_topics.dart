// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    super.key,
  });

  final List<Tag> tags;
  final void Function(BuildContext context, Tag tag) onTagSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));

    return SizedBox(
      width: double.infinity,
      height: kSizeRecommendedTopic,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (Tag tag in tags) ...<Widget>[
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
        ].spaceWithHorizontal(kPaddingSmall),
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
