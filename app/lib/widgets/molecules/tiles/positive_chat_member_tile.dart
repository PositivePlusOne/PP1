// Flutter imports:
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import '../../../providers/system/design_controller.dart';

class PositiveChatMemberTile extends ConsumerWidget {
  const PositiveChatMemberTile({
    required this.onTap,
    required this.profile,
    this.isSelected = false,
    this.isEnabled = true,
    this.displaySelectToggle = true,
    Key? key,
  }) : super(key: key);

  final Profile profile;

  final bool isSelected;
  final bool isEnabled;

  final bool displaySelectToggle;
  final void Function() onTap;

  static const double kSelectSize = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String tagline = profile.getTagline(localizations);

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: isEnabled,
      showDisabledState: false,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kBorderRadiusMassive),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PositiveProfileCircularIndicator(profile: profile),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.displayName.asHandle, style: typography.styleTitle),
                  Text(tagline, style: typography.styleSubtext.copyWith(color: colors.colorGray3)),
                ],
              ),
            ),
            if (displaySelectToggle) ...<Widget>[
              Padding(
                padding: const EdgeInsets.only(right: kPaddingSmall),
                child: Align(
                  alignment: Alignment.center,
                  child: isSelected ? const Icon(UniconsSolid.check_circle, size: kSelectSize) : const Icon(UniconsLine.circle, size: kSelectSize),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
