// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:entry/entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

class PositiveTileEntryAnimation extends ConsumerWidget {
  const PositiveTileEntryAnimation({
    required this.child,
    this.direction = AxisDirection.left,
    this.index = 0,
    super.key,
  });

  final Widget child;
  final AxisDirection direction;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size size = mediaQueryData.size;
    final double width = size.width * 0.1;
    final double height = size.height * 0.1;

    final double xOffset = direction == AxisDirection.left
        ? -width
        : direction == AxisDirection.right
            ? width
            : 0.0;

    final double yOffset = direction == AxisDirection.up
        ? -height
        : direction == AxisDirection.down
            ? height
            : 0.0;

    final Duration delay = index == 0 ? Duration.zero : kAnimationDurationFast * index;

    return Entry.all(
      opacity: 0.0,
      scale: 1.0,
      angle: 0.0,
      xOffset: xOffset,
      yOffset: yOffset,
      duration: kAnimationDurationEntry,
      delay: delay,
      child: child,
    );
  }
}
