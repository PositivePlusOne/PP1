// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../../dtos/database/guidance/guidance_article.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../guidance_categories.dart';

class GuidanceCategoryListBuilder implements ContentBuilder {
  final String? title;
  final List<GuidanceCategory> gcs;
  final List<GuidanceArticle> gas;

  const GuidanceCategoryListBuilder(this.title, this.gcs, this.gas);

  @override
  Widget build() => GuidanceCategoryList(title, gcs, gas);
}
