import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ppoa/resources/resources.dart';

void main() {
  test('markdown_features assets test', () {
    expect(File(MarkdownFeatures.connectionsEn).existsSync(), true);
    expect(File(MarkdownFeatures.educationEn).existsSync(), true);
    expect(File(MarkdownFeatures.guidanceEn).existsSync(), true);
  });
}
