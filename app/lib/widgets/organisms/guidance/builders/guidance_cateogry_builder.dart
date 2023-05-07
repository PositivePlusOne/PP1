// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../../dtos/database/guidance/guidance_category.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../guidance_categories.dart';

class GuidanceCategoryListBuilder implements ContentBuilder {
  final String title;
  final List<GuidanceCategory> gcs;
  final GuidanceCategoryCallback gcb;

  const GuidanceCategoryListBuilder(this.title, this.gcs, this.gcb);

  @override
  Widget build() => GuidanceCategoryList(title, gcs, gcb);
}
