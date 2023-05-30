// Flutter imports:

// Project imports:
import 'package:app/extensions/widget_extensions.dart';
// Flutter imports:
import 'package:app/widgets/organisms/guidance/guidance_article.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/database/guidance/guidance_article.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

class GuidanceCategoryList extends ConsumerWidget {
  final String? title;
  final List<GuidanceCategory> gcs;
  final List<GuidanceArticle> gas;

  const GuidanceCategoryList(this.title, this.gcs, this.gas, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final guidanceController = ref.read(guidanceControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          getTitle(guidanceController.guidanceSection),
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        for (final gc in gcs) ...[
          GuidanceCategoryTile(gc, guidanceController.guidanceCategoryCallback),
        ],
        if (gcs.isEmpty && gas.isEmpty) ...[
          Text(
            'Hmmmmm, there seems to be nothing here. Sorry about that!',
            style: typography.styleBody.copyWith(color: colors.black),
            textAlign: TextAlign.center,
          ),
        ],
        if (gas.isNotEmpty) ...[
          Text(
            'Guidance',
            style: typography.styleTopic.copyWith(color: colors.colorGray6),
          ),
        ],
        for (final ga in gas) ...[
          GuidanceArticleTile(ga),
        ]
      ].spaceWithVertical(kPaddingMedium),
    );
  }

  String getTitle(GuidanceSection? gs) {
    if (title != null) {
      return title!;
    }

    switch (gs) {
      case GuidanceSection.appHelp:
        return 'App Help';
      default:
        return 'Guidance';
    }
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
