import 'dart:io';

import 'package:ppoa/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('mock_images assets test', () {
    expect(File(MockImages.bike).existsSync(), true);
  });
}
