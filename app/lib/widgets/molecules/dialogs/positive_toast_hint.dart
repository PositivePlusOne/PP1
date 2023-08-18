// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class PositiveToastHint extends ConsumerWidget {
  const PositiveToastHint({
    required this.text,
    required this.isShowing,
    super.key,
  });

  final bool isShowing;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        duration: kAnimationDurationRegular,
        opacity: isShowing ? 1 : 0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
          padding: const EdgeInsets.all(kPaddingSmall),
          constraints: const BoxConstraints(maxWidth: 270),
          color: colors.black.withOpacity(0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(UniconsLine.pathfinder, color: colors.white, size: 24),
              Text(
                text,
                textAlign: TextAlign.center,
                style: typography.styleButtonBold.copyWith(color: colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
