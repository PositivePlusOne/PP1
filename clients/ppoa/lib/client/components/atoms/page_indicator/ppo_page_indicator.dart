import 'package:flutter/material.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PPOPageIndicator extends StatelessWidget {
  const PPOPageIndicator({
    required this.branding,
    required this.pagesNum,
    required this.currentPage,
    super.key,
  });

  final DesignSystemBrand branding;
  final int pagesNum;
  final double currentPage;
  static const double opacityInactive = 0.25;
  static const double size = 5.0;
  static const double spacing = 10.0;
  static const double scaleFactor = 2.0;

  @override
  Widget build(BuildContext context) {
    return SmoothIndicator(
      offset: currentPage,
      count: pagesNum,
      effect: ScaleEffect(
        dotColor: branding.colors.colorBlack.withOpacity(opacityInactive),
        activeDotColor: branding.colors.colorBlack,
        scale: scaleFactor,
        dotHeight: size,
        dotWidth: size,
        spacing: spacing,
      ),
    );
  }
}
