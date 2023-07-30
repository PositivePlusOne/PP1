// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import 'builders/builder.dart';
import 'guidance_article.dart';
import 'guidance_categories.dart';

class GuidanceSearchResults extends ConsumerWidget {
  const GuidanceSearchResults({
    required this.categories,
    required this.articles,
    required this.controller,
    required this.state,
    super.key,
  });

  final GuidanceController controller;
  final GuidanceControllerState state;

  final List<GuidanceCategory> categories;
  final List<GuidanceArticle> articles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (categories.isNotEmpty) ...[
            Text(
              'Categories',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
          ],
          for (final category in categories) ...[
            GuidanceCategoryTile(category: category, onCategorySelected: controller.guidanceCategoryCallback),
          ],
          if (articles.isNotEmpty) ...[
            Text(
              'Articles',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
          ],
          for (final article in articles) ...[
            GuidanceArticleTile(
              article: article,
              onTap: () => controller.pushGuidanceArticle(article),
            ),
          ],
          if (categories.isEmpty && articles.isEmpty) ...[
            Text(
              'Hmmmmm, there seems to be nothing here. Sorry about that!',
              style: typography.styleBody.copyWith(color: colors.black),
              textAlign: TextAlign.left,
            ),
          ]
        ].spaceWithVertical(kPaddingMedium),
      ),
    );
  }
}

class GuidanceSearchResultsBuilder implements ContentBuilder {
  final List<GuidanceCategory> categories;
  final List<GuidanceArticle> articles;
  final GuidanceController controller;
  final GuidanceControllerState state;

  const GuidanceSearchResultsBuilder(this.categories, this.articles, this.controller, this.state);

  @override
  Widget build() => GuidanceSearchResults(
        articles: articles,
        categories: categories,
        controller: controller,
        state: state,
      );
}
