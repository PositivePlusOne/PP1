// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:ppoa/resources/resources.dart';

void main() {
  test('markdown_features assets test', () {
    expect(File(MarkdownFeatures.oneEn).existsSync(), true);
    expect(File(MarkdownFeatures.threeEn).existsSync(), true);
    expect(File(MarkdownFeatures.twoEn).existsSync(), true);
  });
}
