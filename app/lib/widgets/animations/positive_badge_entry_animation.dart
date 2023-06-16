// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:entry/entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

class PositiveBadgeEntryAnimation extends ConsumerWidget {
  const PositiveBadgeEntryAnimation({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Entry.all(
      opacity: 0.0,
      scale: 0.0,
      duration: kAnimationDurationExtended,
      delay: kAnimationDurationRegular,
      child: child,
    );
  }
}
