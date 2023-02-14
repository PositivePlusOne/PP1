// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:app/resources/resources.dart';

void main() {
  test('mock_images assets test', () {
    expect(File(MockImages.bike).existsSync(), true);
  });
}
