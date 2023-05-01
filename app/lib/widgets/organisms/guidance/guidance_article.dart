import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      onTap: () {
        controller.pushGuidanceArticle(ga);
      },
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
        Markdown(
          data: ga.body,
          padding: EdgeInsets.zero,
          styleSheet: markdownStyleSheet,
          shrinkWrap: true,
        )
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}
