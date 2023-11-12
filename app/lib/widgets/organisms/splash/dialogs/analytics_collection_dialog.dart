// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../../providers/system/design_controller.dart';

class AnalyticsCollectionDialog extends HookConsumerWidget {
  const AnalyticsCollectionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Column(
      children: <Widget>[
        Text(
          'Enable analytics to help us improve the app and your experience.',
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context, true),
          label: 'Accept and Continue',
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
        ),
        const SizedBox(height: kPaddingSmall),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context, false),
          label: 'Continue without Analytics',
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}
