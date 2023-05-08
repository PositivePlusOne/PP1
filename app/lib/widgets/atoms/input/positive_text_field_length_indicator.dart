// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveTextFieldLengthIndicator extends ConsumerWidget {
  const PositiveTextFieldLengthIndicator({
    this.leading = '',
    this.isFocused = false,
    this.currentLength = 0,
    this.focusColor = Colors.black,
    required this.maximumLength,
    super.key,
  });

  final String leading;

  final int currentLength;
  final int maximumLength;

  final bool isFocused;
  final Color focusColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final locale = AppLocalizations.of(context)!;

    final int remainingCharacters = (maximumLength - currentLength).clamp(0, double.infinity).toInt();

    return RichText(
      text: TextSpan(
        style: typography.styleButtonRegular.copyWith(color: focusColor),
        text: "$leading ",
        children: [
          TextSpan(
            style: typography.styleButtonRegular.copyWith(
              color: colors.black.withOpacity(0.5),
            ),
            text: "($remainingCharacters ${locale.shared_characters_remaining})",
          ),
        ],
      ),
    );
  }
}
