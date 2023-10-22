// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../constants/design_constants.dart';

class PositiveFakeTextFieldButton extends ConsumerWidget {
  const PositiveFakeTextFieldButton({
    required this.onTap,
    this.isEnabled = true,
    this.labelText = ' ',
    this.hintText = ' ',
    this.tintColor,
    this.backgroundColor,
    this.suffixIcon,
    this.prefixIcon,
    super.key,
  });

  final String labelText;
  final String hintText;

  final Color? tintColor;
  final Color? backgroundColor;

  final bool isEnabled;

  final FutureOr<void> Function(BuildContext context) onTap;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  static const double kBorderWidthFocused = 1.0;
  static const double kMinimumHeight = 48.0;
  static const double kMinimumTextColumnHeight = 40.0;

  factory PositiveFakeTextFieldButton.profile({
    required void Function(BuildContext context) onTap,
    labelText = ' ',
    hintText = ' ',
    tintColor,
  }) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    return PositiveFakeTextFieldButton(
      onTap: onTap,
      labelText: labelText,
      hintText: hintText,
      tintColor: tintColor,
      suffixIcon: Container(
        width: kIconLarge,
        height: kIconLarge,
        decoration: BoxDecoration(
          color: colors.purple,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        child: Icon(
          UniconsLine.angle_right,
          color: colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final double leftPadding = prefixIcon != null ? kPaddingExtraSmall : kPaddingLarge;

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: isEnabled,
      child: Container(
        constraints: const BoxConstraints(minHeight: kMinimumHeight),
        decoration: BoxDecoration(
          border: Border.all(
            color: tintColor ?? colors.colorGray6,
            width: kBorderWidthFocused,
            style: BorderStyle.solid,
          ),
          color: backgroundColor ?? colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(kBorderRadiusHuge)),
        ),
        padding: EdgeInsets.fromLTRB(leftPadding, kPaddingExtraSmall, kPaddingExtraSmall, kPaddingExtraSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (prefixIcon != null) ...<Widget>[
              IgnorePointer(child: prefixIcon ?? const SizedBox.shrink()),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hintText,
                    style: typography.styleSubtextBold.copyWith(color: colors.colorGray6),
                    maxLines: 2,
                  ),
                  // Take away some padding to compensate for bad monospace font
                  const SizedBox(height: kPaddingExtraSmall),
                  Text(
                    labelText,
                    style: typography.styleButtonRegular.copyWith(color: colors.black),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            if (suffixIcon != null) ...<Widget>[
              IgnorePointer(child: suffixIcon ?? const SizedBox.shrink()),
            ],
          ],
        ),
      ),
    );
  }
}
