// Flutter imports:

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
  final GuidanceCategoryCallback gcb;

  const GuidanceCategoryList(this.title, this.gcs, this.gcb, {super.key});

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
          GuidanceCategoryTile(gc, gcb),
        ],
        if (gcs.isEmpty) ...[
          Text(
            'Hmmmmm, there seems to be nothing here. Sorry about that!',
            style: typography.styleBody.copyWith(color: colors.black),
            textAlign: TextAlign.center,
          ),
        ]
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}

class GuidanceCategoryTile extends StatelessWidget {
  final GuidanceCategory gc;
  final GuidanceCategoryCallback gcb;

  const GuidanceCategoryTile(this.gc, this.gcb, {super.key});

  @override
  Widget build(BuildContext context) {
    return PositiveListTile(
      title: gc.title,
      subtitle: gc.body,
      onTap: () => gcb(gc),
    );
  }
}
