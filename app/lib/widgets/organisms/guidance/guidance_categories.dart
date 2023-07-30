// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/widgets/organisms/guidance/guidance_article.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/database/guidance/guidance_article.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

class GuidanceCategoryList extends ConsumerWidget {
  const GuidanceCategoryList({
    required this.categories,
    required this.articles,
    required this.controller,
    this.title,
    super.key,
  });

  final List<GuidanceCategory> categories;
  final List<GuidanceArticle> articles;
  final GuidanceController controller;
  final String? title;

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

  String getArticleTitle(GuidanceSection? gs) {
    switch (gs) {
      case GuidanceSection.appHelp:
        return 'Help';
      default:
        return 'Guidance';
    }
  }

  TextStyle getArticleTitleStyle(GuidanceSection? gs) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    switch (gs) {
      case GuidanceSection.appHelp:
        return typography.styleBody.copyWith(fontSize: 14, fontWeight: FontWeight.w900, color: colors.colorGray4);
      default:
        return typography.styleBody.copyWith(fontSize: 14, fontWeight: FontWeight.w900, color: colors.colorGray4);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.read(designControllerProvider.select((value) => value.typography));
    final colors = ref.read(designControllerProvider.select((value) => value.colors));

    final String actualTitle = getTitle(controller.guidanceSection);
    final String actualArticleTitle = getArticleTitle(controller.guidanceSection);
    final TextStyle actualArticleTitleStyle = getArticleTitleStyle(controller.guidanceSection);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
          child: Text(
            actualTitle,
            style: typography.styleSuperSize.copyWith(color: colors.black),
          ),
        ),
        kPaddingSmall.asVerticalBox,
        for (final category in categories)
          ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
              child: GuidanceCategoryTile(category: category, onCategorySelected: controller.guidanceCategoryCallback),
            ),
          ].spaceWithVertical(kPaddingVerySmall),
        if (categories.isEmpty && articles.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            child: Text(
              'Hmmmmm, there seems to be nothing here. Sorry about that!',
              style: typography.styleBody.copyWith(color: colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
        if (articles.isNotEmpty) ...[
          kPaddingSmall.asVerticalBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            child: Text(actualArticleTitle, style: actualArticleTitleStyle),
          ),
        ],
        for (final article in articles) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            child: GuidanceArticleTile(
              article: article,
              onTap: () => controller.pushGuidanceArticle(article),
            ),
          ),
        ]
      ].spaceWithVertical(kPaddingVerySmall),
    );
  }
}

class GuidanceCategoryTile extends StatelessWidget {
  const GuidanceCategoryTile({
    required this.category,
    required this.onCategorySelected,
    super.key,
  });

  final GuidanceCategory category;
  final GuidanceCategoryCallback onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return PositiveListTile(
      title: category.title,
      subtitle: category.body,
      onTap: () => onCategorySelected(category),
    );
  }
}
