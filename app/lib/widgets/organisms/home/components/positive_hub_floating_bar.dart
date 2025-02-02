// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/widgets/molecules/content/positive_recommended_topics.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';

class PositiveHubFloatingBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveHubFloatingBar({
    required this.tabs,
    required this.onTapped,
    this.topics = const <Tag>[],
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.onTopicSelected,
    this.onSeeMoreTopicsSelected,
    this.index = -1,
    this.currentProfile,
    super.key,
  });

  final List<PositiveTabEntry> tabs;
  final int index;
  final Future<void> Function(int index) onTapped;
  final List<Tag> topics;

  final Profile? currentProfile;

  final void Function(BuildContext context, Tag tag)? onTopicSelected;
  final void Function(BuildContext context)? onSeeMoreTopicsSelected;

  final EdgeInsets? margin;

  static const double kTabBarHeight = 30.0;
  static const double kRecommendedPostIndicatorHeight = kPaddingSmall;
  static const double kBorderRadius = 200.0;

  double get totalHeight => kTabBarHeight + kRecommendedTopicHeight + kRecommendedPostIndicatorHeight + kPaddingSmall + (margin?.vertical ?? 0);
  double get kRecommendedTopicHeight {
    if (topics.isNotEmpty) {
      return kSizeRecommendedTopic + kPaddingMedium;
    } else {
      return 0;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasMultipleTabs = tabs.where((element) => element.isEnabled).length > 1;
    return Column(
      children: [
        const SizedBox(height: kPaddingMedium),
        if (topics.isNotEmpty) ...{
          PositiveRecommendedTopics(
            tags: topics,
            onTagSelected: (context, tag) => onTopicSelected?.call(context, tag),
            canSeeMore: currentProfile != null,
            onSeeMoreSelected: (context) => onSeeMoreTopicsSelected?.call(context),
          ),
        },
        const SizedBox(height: kPaddingMedium),
        if (hasMultipleTabs) ...[
          PositiveTabBar(
            index: index,
            onTapped: onTapped,
            tabs: tabs,
          ),
        ],
      ],
    );
  }
}
