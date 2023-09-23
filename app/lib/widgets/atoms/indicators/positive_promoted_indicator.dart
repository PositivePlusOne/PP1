import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class PositivePromotedIndicator extends ConsumerWidget {
  const PositivePromotedIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingVerySmall,
        vertical: kPaddingSuperSmall,
      ),
      decoration: BoxDecoration(
        color: colours.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(UniconsLine.external_link_alt, size: kIconExtraSmall, color: colours.black),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            localisations.post_promoted_label,
            style: typography.styleSubtextBold.copyWith(color: colours.black),
          ),
        ],
      ),
    );
  }
}
