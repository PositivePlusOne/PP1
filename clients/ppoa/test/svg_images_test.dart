import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ppoa/resources/resources.dart';

void main() {
  test('svg_images assets test', () {
    expect(File(SvgImages.decorationArrowHollowLeft).existsSync(), true);
    expect(File(SvgImages.decorationArrowHollowRight).existsSync(), true);
    expect(File(SvgImages.decorationArrowLeft).existsSync(), true);
    expect(File(SvgImages.decorationArrowRight).existsSync(), true);
    expect(File(SvgImages.decorationEye).existsSync(), true);
    expect(File(SvgImages.decorationEyeHollow).existsSync(), true);
    expect(File(SvgImages.decorationFace).existsSync(), true);
    expect(File(SvgImages.decorationFlower).existsSync(), true);
    expect(File(SvgImages.decorationGlobe).existsSync(), true);
    expect(File(SvgImages.decorationLozengeBl).existsSync(), true);
    expect(File(SvgImages.decorationLozengeBr).existsSync(), true);
    expect(File(SvgImages.decorationLozengeTl).existsSync(), true);
    expect(File(SvgImages.decorationLozengeTr).existsSync(), true);
    expect(File(SvgImages.decorationRings).existsSync(), true);
    expect(File(SvgImages.decorationRingsCut).existsSync(), true);
    expect(File(SvgImages.decorationStampCertified).existsSync(), true);
    expect(File(SvgImages.decorationStampStar).existsSync(), true);
    expect(File(SvgImages.decorationStar).existsSync(), true);
    expect(File(SvgImages.decorationTree).existsSync(), true);
    expect(File(SvgImages.footerLogo).existsSync(), true);
    expect(File(SvgImages.stampFist).existsSync(), true);
    expect(File(SvgImages.stampPlusOne).existsSync(), true);
    expect(File(SvgImages.stampSmile).existsSync(), true);
    expect(File(SvgImages.stampVictoryHand).existsSync(), true);
  });
}
