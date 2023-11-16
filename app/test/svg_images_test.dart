// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:app/resources/resources.dart';

void main() {
  test('svg_images assets test', () {
    expect(File(SvgImages.decorationArrowHollowLeft).existsSync(), isTrue);
    expect(File(SvgImages.decorationArrowHollowRight).existsSync(), isTrue);
    expect(File(SvgImages.decorationArrowLeft).existsSync(), isTrue);
    expect(File(SvgImages.decorationArrowRight).existsSync(), isTrue);
    expect(File(SvgImages.decorationEye).existsSync(), isTrue);
    expect(File(SvgImages.decorationEyeHollow).existsSync(), isTrue);
    expect(File(SvgImages.decorationFace).existsSync(), isTrue);
    expect(File(SvgImages.decorationFlower).existsSync(), isTrue);
    expect(File(SvgImages.decorationGlobe).existsSync(), isTrue);
    expect(File(SvgImages.decorationLozengeBl).existsSync(), isTrue);
    expect(File(SvgImages.decorationLozengeBr).existsSync(), isTrue);
    expect(File(SvgImages.decorationLozengeTl).existsSync(), isTrue);
    expect(File(SvgImages.decorationLozengeTr).existsSync(), isTrue);
    expect(File(SvgImages.decorationRings).existsSync(), isTrue);
    expect(File(SvgImages.decorationRingsCut).existsSync(), isTrue);
    expect(File(SvgImages.decorationStampCertified).existsSync(), isTrue);
    expect(File(SvgImages.decorationStampStar).existsSync(), isTrue);
    expect(File(SvgImages.decorationStar).existsSync(), isTrue);
    expect(File(SvgImages.decorationTree).existsSync(), isTrue);
    expect(File(SvgImages.logosCircular).existsSync(), isTrue);
    expect(File(SvgImages.logosFooter).existsSync(), isTrue);
    expect(File(SvgImages.stampFist).existsSync(), isTrue);
    expect(File(SvgImages.stampPlusOne).existsSync(), isTrue);
    expect(File(SvgImages.stampSmile).existsSync(), isTrue);
    expect(File(SvgImages.stampVictoryHand).existsSync(), isTrue);
  });
}
