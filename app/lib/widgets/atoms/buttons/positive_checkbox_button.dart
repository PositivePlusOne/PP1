import 'dart:async';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_checkbox.dart';
import 'package:app/widgets/atoms/buttons/positive_switch.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dtos/system/design_colors_model.dart';

class PositiveCheckboxButton extends ConsumerWidget {
  const PositiveCheckboxButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTapped,
    this.isBusy = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool value;

  final FutureOr<void> Function() onTapped;
  final bool isBusy;

  static const double kButtonHeight = 50.0;
  static const double kIconRadius = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: onTapped,
      isEnabled: !isBusy,
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
            Icon(icon, size: kIconRadius, color: colors.colorGray7),
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
              onTapped: () {},
            ),
          ],
        ),
      ),
    );
  }
}
