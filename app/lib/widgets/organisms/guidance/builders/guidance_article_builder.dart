// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/providers/guidance/guidance_controller.dart';
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import 'package:app/widgets/organisms/guidance/guidance_article.dart';

class GuidanceArticleBuilder implements ContentBuilder {
  const GuidanceArticleBuilder({
    required this.article,
    required this.controller,
  });

  final GuidanceArticle article;
  final GuidanceController controller;

  @override
  Widget build() => GuidanceArticleContent(article);
}
