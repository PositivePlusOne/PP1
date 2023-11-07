// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class PositivePromotedIndicator extends ConsumerWidget {
  const PositivePromotedIndicator({
    required this.invertColour,
    super.key,
  });

  final bool invertColour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingSmall,
        vertical: kPaddingExtraSmall,
      ),
      decoration: BoxDecoration(
        color: invertColour ? colours.colorGray1 : colours.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(UniconsLine.external_link_alt, size: kIconExtraSmall, color: colours.colorGray7),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            localisations.post_promoted_label,
            style: typography.styleSubtextBold.copyWith(color: colours.colorGray7),
          ),
        ],
      ),
    );
  }
}
