// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveTextFieldText extends ConsumerWidget {
  const PositiveTextFieldText({
    super.key,
    required this.text,
    this.textStyle,
    this.isEnabled = true,
    this.onTap,
  });

  final String text;
  final TextStyle? textStyle;

  final bool isEnabled;
  final Future<void> Function(BuildContext context)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return PositiveTapBehaviour(
      onTap: onTap ?? (context) => FocusManager.instance.primaryFocus?.unfocus(),
      isEnabled: isEnabled,
      showDisabledState: !isEnabled,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: kMinimumTapTargetSize,
          minWidth: kMinimumTapTargetSize,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle ??
                typography.styleButtonRegular.copyWith(
                  color: colors.colorGray4,
                ),
          ),
        ),
      ),
    );
  }
}
