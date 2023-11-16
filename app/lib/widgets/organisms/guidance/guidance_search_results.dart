// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import 'package:app/widgets/organisms/guidance/guidance_directory.dart';
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
    required this.directoryEntries,
    required this.controller,
    required this.state,
    super.key,
  });

  final GuidanceController controller;
  final GuidanceControllerState state;

  final List<GuidanceCategory> categories;
  final List<GuidanceDirectoryEntry> directoryEntries;
  final List<GuidanceArticle> articles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final GuidanceSection? section = state.guidanceSection;

    final String emptyTitle = switch (section) {
      GuidanceSection.directory => 'No organisations found',
      (_) => 'No guidance found',
    };

    final String emptyBody = switch (section) {
      GuidanceSection.directory => 'We couldn\'t find anything in our Directory matching your search term',
      (_) => 'We couldn\'t find anything in our Guidance matching your search term',
    };

    return Padding(
      padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kPaddingExtraSmall),
          if (categories.isNotEmpty) ...[
            Text(
              'Categories',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            for (final category in categories) ...[
              GuidanceCategoryTile(
                category: category,
                onCategorySelected: controller.guidanceCategoryCallback,
                isBusy: false,
              ),
            ],
          ],
          if (articles.isNotEmpty) ...[
            Text(
              'Articles',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            for (final article in articles) ...[
              GuidanceArticleTile(
                article: article,
                isBusy: false,
                onTap: (_) => controller.pushGuidanceArticle(article),
              ),
            ],
          ],
          if (directoryEntries.isNotEmpty) ...<Widget>[
            Text(
              'Directory Entries',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            for (final directoryEntry in directoryEntries) ...[
              GuidanceDirectoryTile(
                entry: directoryEntry,
                isBusy: false,
              ),
            ],
          ],
          if (categories.isEmpty && articles.isEmpty && directoryEntries.isEmpty) ...[
            Text(
              emptyTitle,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            Text(
              emptyBody,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
          ]
        ].spaceWithVertical(kPaddingMedium),
      ),
    );
  }
}

class GuidanceSearchResultsBuilder implements ContentBuilder {
  const GuidanceSearchResultsBuilder({
    required this.controller,
    required this.state,
    this.categories = const [],
    this.articles = const [],
    this.directoryEntries = const [],
  });

  final List<GuidanceCategory> categories;
  final List<GuidanceArticle> articles;
  final List<GuidanceDirectoryEntry> directoryEntries;

  final GuidanceController controller;
  final GuidanceControllerState state;

  bool get isEmpty => categories.isEmpty && articles.isEmpty && directoryEntries.isEmpty;

  @override
  List<PositiveScaffoldDecoration> get decorations {
    if (isEmpty) {
      final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
      return buildType1ScaffoldDecorations(colors);
    }

    return [];
  }

  @override
  Widget build() => GuidanceSearchResults(
        articles: articles,
        categories: categories,
        directoryEntries: directoryEntries,
        controller: controller,
        state: state,
      );
}
