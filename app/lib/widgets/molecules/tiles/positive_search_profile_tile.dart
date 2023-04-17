// Dart imports:
import 'dart:async';

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
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/database/user/user_profile.dart';
import '../../../providers/system/design_controller.dart';

class PositiveSearchProfileTile extends ConsumerWidget {
  const PositiveSearchProfileTile({
    required this.profile,
    this.onTap,
    this.onOptionsTapped,
    this.isEnabled = true,
    super.key,
  });

  final UserProfile profile;
  final FutureOr<void> Function()? onTap;
  final FutureOr<void> Function()? onOptionsTapped;
  final bool isEnabled;

  static const double kProfileTileHeight = 72.0;
  static const double kProfileTileBorderRadius = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String tagline = profile.getTagline(localizations);

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: isEnabled,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: kProfileTileHeight,
          maxHeight: kProfileTileHeight,
        ),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kProfileTileBorderRadius),
        ),
        padding: const EdgeInsets.all(kPaddingSmall),
        child: Row(
          children: <Widget>[
            PositiveProfileCircularIndicator(userProfile: profile, size: kIconHuge),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    profile.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.styleTitle.copyWith(color: colors.colorGray7),
                  ),
                  Text(
                    tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            PositiveButton(
              colors: colors,
              primaryColor: colors.colorGray7,
              icon: UniconsSolid.ellipsis_h,
              layout: PositiveButtonLayout.iconOnly,
              style: PositiveButtonStyle.text,
              onTapped: () => onOptionsTapped?.call(),
              isDisabled: !isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
