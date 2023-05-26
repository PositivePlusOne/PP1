// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../guidance_categories.dart';

class GuidanceCategoryListBuilder implements ContentBuilder {
  final String? title;
  final List<GuidanceCategory> gcs;

  const GuidanceCategoryListBuilder(this.title, this.gcs);

  @override
  Widget build() => GuidanceCategoryList(title, gcs);
}
