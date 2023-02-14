// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';

class PositivePageIndicator extends StatelessWidget {
  const PositivePageIndicator({
    required this.colors,
    required this.pagesNum,
    required this.currentPage,
    super.key,
  });

  final DesignColorsModel colors;
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
        dotColor: colors.black.withOpacity(opacityInactive),
        activeDotColor: colors.black,
        scale: scaleFactor,
        dotHeight: size,
        dotWidth: size,
        spacing: spacing,
      ),
    );
  }
}
