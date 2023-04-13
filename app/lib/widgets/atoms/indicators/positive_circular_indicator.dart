// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

class PositiveCircularIndicator extends ConsumerWidget {
  const PositiveCircularIndicator({
    required this.child,
    this.ringColor = Colors.black,
    this.size = kIconLarge,
    super.key,
  });

  final Widget child;

  final Color ringColor;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(kPaddingThin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        border: Border.all(
          color: ringColor,
          width: kBorderThicknessSmall,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        child: Container(
          color: ringColor,
          child: child,
        ),
      ),
    );
  }
}
