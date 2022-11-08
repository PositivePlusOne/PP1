// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:ppoa/resources/resources.dart';

void main() {
  test('svg_images assets test', () {
    expect(File(SvgImages.stampFist).existsSync(), true);
    expect(File(SvgImages.stampPlusOne).existsSync(), true);
    expect(File(SvgImages.stampSmile).existsSync(), true);
    expect(File(SvgImages.stampVictoryHand).existsSync(), true);
  });
}
