// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/extensions/color_extensions.dart';

Color colorFromJson(String color) {
  return color.toColorFromHex();
}

String colorToJson(Color object) {
  return object.toHex();
}
