// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PositivePageIndicator extends StatelessWidget {
  const PositivePageIndicator({
    required this.color,
    required this.pagesNum,
    required this.currentPage,
    super.key,
  });

  final Color color;
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
      size: const Size.square(size),
      effect: ScaleEffect(
        dotColor: color.withOpacity(opacityInactive),
        activeDotColor: color,
        scale: scaleFactor,
        dotHeight: size,
        dotWidth: size,
        spacing: spacing,
      ),
    );
  }
}
