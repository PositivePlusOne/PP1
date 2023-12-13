// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

/// A custom switch widget that represents a positive state with a green color when active.
/// This switch is built with Riverpod and hooks, and uses [AnimatedPositioned] to animate the switch dial.
class PositiveSwitch extends ConsumerWidget {
  /// Creates a new [PositiveSwitch] instance.
  ///
  /// [value] indicates the current state of the switch (true = active, false = inactive).
  /// [onTapped] is an optional callback function to execute when the switch is tapped.
  /// [ignoring] is an optional parameter, which when set to true, ignores the tap gestures on the switch.
  /// [isEnabled] is an optional parameter, which is true by default, to enable or disable the switch.
  const PositiveSwitch({
    required this.value,
    required this.ignoring,
    this.onTapped,
    this.activeColour,
    this.inactiveColour,
    this.isEnabled = true,
    super.key,
  });

  final bool value;
  final FutureOr<void> Function(BuildContext context)? onTapped;

  final bool isEnabled;
  final bool ignoring;

  final Color? activeColour;
  final Color? inactiveColour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current design colors from the Riverpod state.
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final Color colour = value ? (activeColour ?? colors.green) : (inactiveColour ?? colors.colorGray7);

    //? size of widget height - the two border radii on both top and bottom
    const double kSwitchDialSize = kPaddingLarge - kBorderThicknessMedium * 4;

    // Build the switch widget.
    return IgnorePointer(
      ignoring: ignoring,
      child: PositiveTapBehaviour(
        onTap: (context) => onTapped?.call(context),
        isEnabled: isEnabled,
        child: Container(
          height: kPaddingLarge,
          width: kPaddingLarge * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusExtraLarge),
            border: Border.all(
              color: colour,
              width: kBorderThicknessMedium,
            ),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: kAnimationDurationRegular,
                curve: Curves.easeInOut,
                top: kBorderThicknessMedium,
                left: value ? (kPaddingLarge + kBorderThicknessMedium) : kBorderThicknessMedium,
                height: kSwitchDialSize,
                width: kSwitchDialSize,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colour,
                    borderRadius: BorderRadius.circular(kBorderRadiusExtraLarge),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
