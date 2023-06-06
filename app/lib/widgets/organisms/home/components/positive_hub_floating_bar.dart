// Flutter imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/widgets/molecules/content/positive_recommended_topics.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';

import '../../../molecules/navigation/positive_tab_bar.dart';

class PositiveHubFloatingBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveHubFloatingBar({
    required this.tabs,
    required this.onTapped,
    required this.activities,
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.index = -1,
    super.key,
  });

  final List<String> tabs;
  final int index;
  final Future<void> Function(int index) onTapped;
  final List<Activity> activities;

  final EdgeInsets? margin;

  static const double kBaseHeight = 30.0;
  static const double kBorderRadius = 200.0;

  double get totalHeight => kBaseHeight + (margin?.vertical ?? 0);

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Column(
      children: [
        PositiveRecommendedTopics(activities: activities),
        PositiveTabBar(
          index: index,
          onTapped: onTapped,
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
