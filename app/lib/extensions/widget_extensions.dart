// Flutter imports:
import 'package:flutter/material.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> spaceWithVertical(double space) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(SizedBox(height: space));
      }
    }

    return result;
  }

  List<Widget> spaceWithHorizontal(double space) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(SizedBox(width: space));
      }
    }

    return result;
  }
}
