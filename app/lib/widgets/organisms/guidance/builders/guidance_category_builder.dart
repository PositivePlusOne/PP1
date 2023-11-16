// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/providers/guidance/guidance_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../../dtos/database/guidance/guidance_article.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../guidance_categories.dart';

class GuidanceCategoryListBuilder implements ContentBuilder {
  const GuidanceCategoryListBuilder({
    required this.title,
    required this.categories,
    required this.articles,
    required this.controller,
    this.isBusy = false,
  });

  final String? title;
  final List<GuidanceCategory> categories;
  final List<GuidanceArticle> articles;
  final GuidanceController controller;
  final bool isBusy;

  @override
  List<PositiveScaffoldDecoration> get decorations => [];

  @override
  Widget build() => GuidanceCategoryList(
        articles: articles,
        categories: categories,
        controller: controller,
        title: title,
        isBusy: isBusy,
      );
}
