// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/widgets/molecules/content/positive_recommended_topics.dart';
import '../../../molecules/navigation/positive_tab_bar.dart';

class PositiveHubFloatingBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveHubFloatingBar({
    required this.tabs,
    required this.onTapped,
    required this.activities,
    required this.tabColours,
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.index = -1,
    super.key,
  });

  final List<String> tabs;
  final int index;
  final Future<void> Function(int index) onTapped;
  final List<Activity> activities;
  final List<Color> tabColours;

  final EdgeInsets? margin;

  static const double kTabBarHeight = 30.0;
  static const double kRecommendedPostIndicatorHeight = kPaddingSmall;
  static const double kBorderRadius = 200.0;

  double get totalHeight => kTabBarHeight + kRecommendedTopicHeight + kRecommendedPostIndicatorHeight + kPaddingSmall + (margin?.vertical ?? 0);
  double get kRecommendedTopicHeight {
    if (activities.isNotEmpty) {
      return kSizeRecommendedTopic + kPaddingMedium;
    } else {
      return 0;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Column(
      children: [
        const SizedBox(height: kPaddingSmall), //TODO: add the indicators
        const SizedBox(height: kPaddingSmall),
        if (activities.isNotEmpty) ...{
          const SizedBox(height: kPaddingMedium),
          PositiveRecommendedTopics(activities: activities),
        },
        PositiveTabBar(
          index: index,
          onTapped: onTapped,
          tabColours: tabColours,
          tabs: const <String>[
            'All',
            'Clips',
            'Events',
            'Posts',
          ],
        ),
      ],
    );
  }
}
