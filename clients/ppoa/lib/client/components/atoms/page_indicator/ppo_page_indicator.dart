// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

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
        dotColor: branding.colors.black.withOpacity(opacityInactive),
        activeDotColor: branding.colors.black,
        scale: scaleFactor,
        dotHeight: size,
        dotWidth: size,
        spacing: spacing,
      ),
    );
  }
}
