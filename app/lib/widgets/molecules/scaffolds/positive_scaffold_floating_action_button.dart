// Dart imports:
import 'dart:async';

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
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveScaffoldFloatingActionButton extends ConsumerWidget {
  const PositiveScaffoldFloatingActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final FutureOr<void> Function(BuildContext)? onTap;

  final IconData? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: onTap,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: colors.black,
            borderRadius: BorderRadius.circular(kBorderRadiusHuge),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingSmallMedium,
            vertical: kPaddingVerySmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: kPaddingExtraSmall),
                child: Icon(
                  icon ?? UniconsLine.angle_double_up,
                  color: colors.white,
                  size: kIconExtraSmall,
                ),
              ),
              Text(
                label,
                style: typography.styleButtonBold.copyWith(color: colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
