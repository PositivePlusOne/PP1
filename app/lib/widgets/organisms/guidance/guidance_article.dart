// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/extensions/widget_extensions.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

class GuidanceArticleList extends ConsumerWidget {
  final String subCategory;
  final List<GuidanceArticle> gas;

  const GuidanceArticleList(this.subCategory, this.gas, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          subCategory,
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        for (final ga in gas) ...[
          GuidanceArticleTile(ga),
        ],
        if (gas.isEmpty) ...[
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

class GuidanceArticleTile extends ConsumerWidget {
  final GuidanceArticle ga;

  const GuidanceArticleTile(this.ga, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuidanceController controller = ref.watch(guidanceControllerProvider.notifier);

    return PositiveListTile(
      title: ga.title,
      onTap: () => controller.pushGuidanceArticle(ga),
    );
  }
}

class GuidanceArticleContent extends ConsumerWidget {
  final GuidanceArticle ga;

  const GuidanceArticleContent(this.ga, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MarkdownStyleSheet markdownStyleSheet = getMarkdownStyleSheet(colors.white, colors, typography);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          ga.title,
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        MarkdownBody(
          data: ga.body,
          styleSheet: markdownStyleSheet,
        )
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}
