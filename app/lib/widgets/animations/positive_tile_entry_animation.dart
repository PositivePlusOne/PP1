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
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double xOffset = mediaQueryData.size.width * 0.1;

    return Entry.all(
      opacity: 0.0,
      scale: 1.0,
      angle: 0.0,
      xOffset: xOffset,
      yOffset: 0.0,
      duration: kAnimationDurationExtended,
      delay: kAnimationDurationRegular,
      child: child,
    );
  }
}
