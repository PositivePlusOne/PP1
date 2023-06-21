// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../resources/resources.dart';
import '../scaffolds/positive_scaffold_decoration.dart';

class PositiveBanner extends StatelessWidget {
  const PositiveBanner({
    super.key,
    required this.colors,
    required this.typography,
    required this.child,
  });

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
            Padding(
              padding: const EdgeInsets.all(kPaddingMedium),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
