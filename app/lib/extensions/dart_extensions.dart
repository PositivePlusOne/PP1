// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';

extension ListExtensions<T> on List<T> {
  T getElementAtModuloIndex(int index) {
    return this[index % length];
  }
}

extension StringExtensions on String? {
  Size getTextSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: this, style: style), maxLines: 1, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  String get asDateString {
    try {
      final DateTime dateTime = DateTime.parse(this ?? '');
      return kDefaultDateFormat.format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String get asHandle => '@$this';
}

extension StringListExtensions on List<String> {
  String get parseAsIdentifier {
    final List<String> split = [...this]..sort();
    return split.join('-');
  }
}
