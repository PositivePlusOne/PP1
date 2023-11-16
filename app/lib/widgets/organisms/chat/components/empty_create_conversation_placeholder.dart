// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class EmptyCreateConversationPlaceholder extends ConsumerWidget {
  const EmptyCreateConversationPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPaddingMassive),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              locale.shared_no_connections,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
          ),
          const SizedBox(height: kPaddingMedium),
          Text(locale.shared_no_connections_subtitle, style: typography.styleSubtitle),
        ],
      ),
    );
  }
}
