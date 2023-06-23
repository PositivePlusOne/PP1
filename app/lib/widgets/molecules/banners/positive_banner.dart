// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../resources/resources.dart';
import '../scaffolds/positive_scaffold_decoration.dart';

enum BannerDecoration {
  type1,
  type2,
  type3,
  type4,
}

class PositiveBanner extends StatelessWidget {
  const PositiveBanner({
    super.key,
    required this.colors,
    required this.typography,
    required this.child,
    this.bannerDecoration = BannerDecoration.type1,
  });

  final BannerDecoration bannerDecoration;
  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Widget child;

  static const double kBorderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Stack(
          children: <Widget>[
            ...buildDecoration(),
            Padding(
              padding: const EdgeInsets.all(kPaddingMedium),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildDecoration() {
    switch (bannerDecoration) {
      case BannerDecoration.type1:
        return bannerDecorationsType1();
      case BannerDecoration.type2:
        return bannerDecorationsType2();
      case BannerDecoration.type3:
        return bannerDecorationsType3();
      case BannerDecoration.type4:
        return bannerDecorationsType4();
    }
  }

  List<Widget> bannerDecorationsType1() {
    return [
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationArrowRight,
        color: colors.yellow,
        alignment: Alignment.centerRight,
        rotationDegrees: -30.0,
        offset: const Offset(50.0, 0),
        scale: 0.8,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationStar,
        color: colors.purple,
        alignment: Alignment.centerRight,
        rotationDegrees: -15.0,
        offset: const Offset(70.0, 60.0),
        scale: 0.8,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationFlower,
        color: colors.green,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(80, -30),
        scale: 0.8,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationRings,
        color: colors.teal,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(65.0, 45.0),
        scale: 0.7,
      ),
    ];
  }

  List<Widget> bannerDecorationsType2() {
    return [
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationRings,
        color: colors.teal,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(130, -25),
        scale: 0.7,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationGlobe,
        color: colors.pink,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(40.0, -30),
        scale: 0.75,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationArrowRight,
        color: colors.yellow,
        alignment: Alignment.centerRight,
        rotationDegrees: -30.0,
        offset: const Offset(80.0, 90.0),
        scale: 0.7,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationEye,
        color: colors.green,
        alignment: Alignment.centerRight,
        rotationDegrees: 40,
        offset: const Offset(110, -25),
        scale: 0.7,
      ),
    ];
  }

  List<Widget> bannerDecorationsType3() {
    return [
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationGlobe,
        color: colors.green,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(90.0, 30.0),
        scale: 0.8,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationStampStar,
        color: colors.purple,
        alignment: Alignment.centerRight,
        rotationDegrees: 0,
        offset: const Offset(25.0, 37.0),
        scale: 0.7,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationFace,
        color: colors.pink,
        alignment: Alignment.centerRight,
        rotationDegrees: 15,
        offset: const Offset(70, -40),
        scale: 0.55,
      ),
    ];
  }

  List<Widget> bannerDecorationsType4() {
    return [
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationStar,
        color: colors.purple,
        alignment: Alignment.centerRight,
        rotationDegrees: -15.0,
        offset: const Offset(30.0, 50.0),
        scale: 1.1,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationRings,
        color: colors.teal,
        alignment: Alignment.centerRight,
        rotationDegrees: -15.0,
        offset: const Offset(0.0, 30.0),
        scale: 0.8,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationArrowRight,
        color: colors.yellow,
        alignment: Alignment.centerRight,
        rotationDegrees: -15.0,
        offset: const Offset(70.0, -20.0),
        scale: 0.6,
      ),
      PositiveScaffoldDecoration(
        asset: SvgImages.decorationEye,
        color: colors.green,
        alignment: Alignment.centerRight,
        rotationDegrees: 20.0,
        offset: const Offset(40.0, -55.0),
        scale: 0.5,
      ),
    ];
  }
}
