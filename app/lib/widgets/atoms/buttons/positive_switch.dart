import 'dart:async';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/system/design_controller.dart';

class PositiveSwitch extends ConsumerWidget {
  const PositiveSwitch({
    required this.value,
    required this.onTapped,
    required this.ignoring,
    this.isEnabled = true,
    super.key,
  });

  final bool value;
  final FutureOr<void> Function() onTapped;

  final bool isEnabled;
  final bool ignoring;

  static const double kSwitchWidth = 56.0;
  static const double kSwitchHeight = 26.0;
  static const double kSwitchBorderWidth = 2.0;

  static const double kSwitchDialRadius = 22.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return IgnorePointer(
      ignoring: ignoring,
      child: PositiveTapBehaviour(
        onTap: onTapped,
        isEnabled: isEnabled,
        child: Container(
          height: kSwitchHeight,
          width: kSwitchWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSwitchHeight),
            border: Border.all(
              color: value ? colors.green : colors.colorGray7,
              width: kSwitchBorderWidth,
            ),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: kAnimationDurationRegular,
                curve: Curves.easeInOut,
                left: value ? 34.0 : 4.0,
                height: 20.0,
                width: 20.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? colors.green : colors.colorGray7,
                    borderRadius: BorderRadius.circular(kSwitchDialRadius),
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
