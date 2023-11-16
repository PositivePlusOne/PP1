// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import '../../../providers/system/design_controller.dart';

class PositiveNumericIndicator extends ConsumerWidget {
  const PositiveNumericIndicator({
    required this.count,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.backgroundColor,
    this.textStyle,
    super.key,
  });

  final int count;
  final double size;
  final double borderThickness;
  final Color? backgroundColor;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final Color actualColor = backgroundColor ?? colors.black;

    return PositiveCircularIndicator(
      ringColor: actualColor,
      borderThickness: borderThickness,
      backgroundColor: colors.black,
      size: size,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '+$count',
          style: textStyle ?? typography.styleTitle.copyWith(color: colors.white),
        ),
      ),
    );
  }
}
