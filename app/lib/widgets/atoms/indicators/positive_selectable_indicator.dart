// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/color_extensions.dart';

class PositiveSelectableIndicator extends ConsumerWidget {
  const PositiveSelectableIndicator({
    super.key,
    this.isSelected = false,
    this.backgroundColor = Colors.white,
  });

  final bool isSelected;
  final Color backgroundColor;

  static const double kIndicatorSize = 24.0;
  static const double kIconSize = 18.0;
  static const double kBorderRadius = 12.0;
  static const double kBorderWidth = 1.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = backgroundColor.complimentTextColor;
    final Color foregroundColor = color.complimentTextColor;

    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      width: kIndicatorSize,
      height: kIndicatorSize,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(
          color: color,
          width: kBorderWidth,
        ),
      ),
      child: AnimatedSwitcher(
        duration: kAnimationDurationRegular,
        child: isSelected
            ? Icon(
                UniconsLine.check,
                size: kIconSize,
                color: foregroundColor,
              )
            : null,
      ),
    );
  }
}
