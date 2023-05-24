// Flutter imports:

import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/extensions/widget_extensions.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import 'builders/builder.dart';
import 'guidance_article.dart';
import 'guidance_categories.dart';

class GuidanceSearchResults extends ConsumerWidget {
  final List<GuidanceCategory> gcs;
  final List<GuidanceArticle> gas;

  const GuidanceSearchResults(this.gcs, this.gas, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final guidanceController = ref.read(guidanceControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (gcs.isNotEmpty) ...[
          Text(
            'Categories',
            style: typography.styleHero.copyWith(color: colors.black),
          ),
        ],
        for (final gc in gcs) ...[
          GuidanceCategoryTile(gc, guidanceController.guidanceCategoryCallback),
        ],
        if (gas.isNotEmpty) ...[
          Text(
            'Articles',
            style: typography.styleHero.copyWith(color: colors.black),
          ),
        ],
        for (final ga in gas) ...[
          GuidanceArticleTile(ga),
        ],
        if (gcs.isEmpty && gas.isEmpty) ...[
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

class GuidanceSearchResultsBuilder implements ContentBuilder {
  final List<GuidanceCategory> gcs;
  final List<GuidanceArticle> gas;

  const GuidanceSearchResultsBuilder(this.gcs, this.gas);

  @override
  Widget build() => GuidanceSearchResults(gcs, gas);
}
