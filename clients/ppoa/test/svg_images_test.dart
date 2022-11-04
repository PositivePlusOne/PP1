import 'dart:io';

import 'package:ppoa/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('svg_images assets test', () {
    expect(File(SvgImages.stampFist).existsSync(), true);
    expect(File(SvgImages.stampPlusOne).existsSync(), true);
    expect(File(SvgImages.stampVictoryHand).existsSync(), true);
  });
}
