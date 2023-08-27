// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/dtos/database/guidance/guidance_category.dart';
import 'package:app/extensions/number_extensions.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

enum GuidanceArticleListType {
  guidance('Guidance'),
  appHelp('Help');

  const GuidanceArticleListType(this.label);
  final String label;
}

class GuidanceArticleTile extends ConsumerWidget {
  final GuidanceArticle article;
  final VoidCallback onTap;

  const GuidanceArticleTile({
    required this.onTap,
    required this.article,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveListTile(
      title: article.title,
      onTap: onTap,
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

    return Padding(
      padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, top: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ga.title,
            style: typography.styleHeroMedium.copyWith(color: colors.black),
          ),
          kPaddingSmall.asVerticalBox,
          buildMarkdownWidgetFromBody(ga.body),
        ],
      ),
    );
  }
}
