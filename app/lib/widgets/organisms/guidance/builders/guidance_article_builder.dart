import 'package:app/widgets/organisms/guidance/guidance_article.dart';
import 'package:flutter/material.dart';

import '../../../../dtos/database/guidance/guidance_article.dart';
import 'builder.dart';

class GuidanceArticleListBuilder implements ContentBuilder {
  final String subCategoryName;
  final List<GuidanceArticle> gas;

  const GuidanceArticleListBuilder(
    this.subCategoryName,
    this.gas,
  );

  @override
  Widget build() {
    return GuidanceArticleList(subCategoryName, gas);
  }
}

class GuidanceArticleContentBuilder implements ContentBuilder {
  final GuidanceArticle ga;

  const GuidanceArticleContentBuilder(this.ga);

  @override
  Widget build() => GuidanceArticleContent(ga);
}
