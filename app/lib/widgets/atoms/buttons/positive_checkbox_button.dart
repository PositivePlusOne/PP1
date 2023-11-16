// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_switch.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/system/design_colors_model.dart';

/// A custom checkbox button widget that displays an icon, label, and an integrated [PositiveSwitch] as a checkbox.
/// This button is built with Riverpod and hooks and is designed to represent a positive state with a green color when active.
class PositiveCheckboxButton extends ConsumerWidget {
  /// Creates a new [PositiveCheckboxButton] instance.
  ///
  /// [label] is the text displayed in the button.
  /// [value] indicates the current state of the switch (true = active, false = inactive).
  /// [onTapped] is the callback function to execute when the button is tapped.
  /// [icon] is an optional icon displayed at the beginning of the button.
  /// [isBusy] is an optional parameter, which is false by default. Set it to true to disable the button.
  const PositiveCheckboxButton({
    required this.label,
    required this.value,
    required this.onTapped,
    this.icon,
    this.isBusy = false,
    this.showDisabledState = false,
    super.key,
  });

  final IconData? icon;
  final String label;
  final bool value;

  final FutureOr<void> Function(BuildContext context) onTapped;
  final bool isBusy;
  final bool showDisabledState;

  // Dimensions and positioning constants for the button and its icon.
  static const double kButtonHeight = 50.0;
  static const double kIconRadius = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current design colors and typography from the Riverpod state.
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    // Build the checkbox button widget.
    return PositiveTapBehaviour(
      onTap: onTapped,
      isEnabled: !isBusy,
      showDisabledState: showDisabledState,
      child: Container(
        height: kButtonHeight,
        width: double.infinity,
        padding: const EdgeInsets.all(kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.colorGray1,
          borderRadius: BorderRadius.circular(kButtonHeight / 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: kIconRadius, color: colors.colorGray7),
            ],
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Text(
                label,
                style: typography.styleButtonBold.copyWith(color: colors.colorGray7),
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            PositiveSwitch(
              value: value,
              ignoring: true,
            ),
          ],
        ),
      ),
    );
  }
}
