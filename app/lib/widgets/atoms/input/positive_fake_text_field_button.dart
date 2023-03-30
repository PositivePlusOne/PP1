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
import '../../../constants/design_constants.dart';

class PositiveFakeTextFieldButton extends ConsumerWidget {
  const PositiveFakeTextFieldButton({
    required this.onTap,
    this.labelText = ' ',
    this.hintText = ' ',
    this.tintColor,
    this.backgroundColor,
    this.suffixIcon,
    super.key,
  });

  final String labelText;
  final String hintText;

  final Color? tintColor;
  final Color? backgroundColor;

  final FutureOr<void> Function() onTap;

  final Widget? suffixIcon;

  static const double kBorderWidthFocused = 1.0;

  factory PositiveFakeTextFieldButton.profile({
    required onTap,
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

    return GestureDetector(
      onTapDown: (_) => onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: tintColor ?? colors.colorGray6,
            width: kBorderWidthFocused,
            style: BorderStyle.solid,
          ),
          color: backgroundColor ?? colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(kBorderRadiusHuge)),
        ),
        padding: const EdgeInsets.all(kPaddingExtraSmall),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: kPaddingLarge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hintText,
                    style: typography.styleSubtextBold.copyWith(color: colors.colorGray6),
                    maxLines: 2,
                  ),
                  const SizedBox(height: kPaddingExtraSmall),
                  Text(
                    labelText,
                    style: typography.styleButtonRegular,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            suffixIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
