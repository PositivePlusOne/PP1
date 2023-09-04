// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';

abstract class ContentBuilder {
  Widget build();

  List<PositiveScaffoldDecoration> get decorations => [];
}
