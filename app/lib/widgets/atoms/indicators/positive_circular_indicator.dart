// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

class PositiveCircularIndicator extends ConsumerWidget {
  const PositiveCircularIndicator({
    required this.child,
    this.ringColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.gapColor,
    super.key,
  });

  final Widget child;

  final Color ringColor;
  final Color backgroundColor;

  final Color? gapColor;

  final double borderThickness;
  final double size;

  double get padding {
    return size > kPaddingAppBarBreak ? kPaddingExtraSmall : kPaddingThin;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      height: size,
      width: size,
      duration: kAnimationDurationRegular,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        color: gapColor,
        border: Border.all(
          color: ringColor,
          width: borderThickness,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        child: AnimatedContainer(
          duration: kAnimationDurationRegular,
          color: backgroundColor,
          child: child,
        ),
      ),
    );
  }
}
