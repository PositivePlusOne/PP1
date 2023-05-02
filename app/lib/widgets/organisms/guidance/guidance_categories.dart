// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/widget_extensions.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

class GuidanceCategoryList extends ConsumerWidget {
  final String title;
  final List<GuidanceCategory> gcs;

  const GuidanceCategoryList(this.title, this.gcs, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        for (final gc in gcs) ...[
          GuidanceCategoryTile(gc),
        ]
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}

class GuidanceCategoryTile extends ConsumerWidget {
  final GuidanceCategory gc;

  const GuidanceCategoryTile(this.gc, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuidanceController controller = ref.watch(guidanceControllerProvider.notifier);
    return PositiveListTile(
      title: gc.title,
      subtitle: gc.body,
      onTap: () {
        if (gc.parent == null) {
          controller.loadGuidanceCategories(gc);
        } else {
          controller.loadArticles(gc);
        }
      },
    );
  }
}
