// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import '../main.dart';
import '../providers/system/design_controller.dart';

Color getSafeProfileColorFromHex(String? color) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

  if (color == null) {
    return colors.teal;
  }

  try {
    return color.toColorFromHex();
  } catch (e) {
    return colors.teal;
  }
}
