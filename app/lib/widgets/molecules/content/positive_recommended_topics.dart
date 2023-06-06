import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dtos/database/activities/activities.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../helpers/list_helpers.dart';
import '../../../providers/system/design_controller.dart';

class PositiveRecommendedTopics extends ConsumerWidget {
  const PositiveRecommendedTopics({
    required this.activities,
    super.key,
  });

  final List<Activity> activities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...addSeparatorsToWidgetList(
              list: [
                for (Activity activity in activities)
                  //TODO(S): malformed posts are ignored, should they error?
                  if (activity.generalConfiguration != null)
                    PositiveRecomemendedTopic(
                      postContent: activity,
                      typeography: typeography,
                      colours: colours,
                    ),
              ],
              separator: const SizedBox(
                width: kPaddingSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositiveRecomemendedTopic extends ConsumerWidget {
  const PositiveRecomemendedTopic({
    required this.postContent,
    required this.typeography,
    required this.colours,
    super.key,
  });

  final Activity postContent;
  final DesignTypographyModel typeography;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveTapBehaviour(
      //TODO(S): Hook up on tap for selcted Topic
      // onTap: (){//?push topic page/action here using postContent},
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
            const Spacer(),
            Text(
              "#",
              style: typeography.styleTopic.copyWith(color: colours.colorGray4),
            ),
            Text(
              postContent.generalConfiguration!.content,
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
