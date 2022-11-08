import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ppoa/resources/resources.dart';

void main() {
  test('svg_images assets test', () {
    expect(File(SvgImages.stampFist).existsSync(), true);
    expect(File(SvgImages.stampPlusOne).existsSync(), true);
    expect(File(SvgImages.stampVictoryHand).existsSync(), true);
    expect(File(SvgImages.stampSmile).existsSync(), true);
  });
}
