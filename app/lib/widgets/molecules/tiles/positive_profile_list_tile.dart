// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileListTile extends ConsumerWidget {
  const PositiveProfileListTile({
    this.profile,
    this.isEnabled = true,
    super.key,
  });

  final Profile? profile;
  final bool isEnabled;

  static const double kProfileTileHeight = 72.0;
  static const double kProfileTileBorderRadius = 40.0;

  Future<void> onOptionsTapped(BuildContext context) async {
    final logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final FirebaseAuth auth = providerContainer.read(firebaseAuthProvider);
    final String uid = profile?.flMeta?.id ?? '';

    logger.d('User profile modal requested: $uid');
    if (uid.isEmpty || auth.currentUser == null) {
      logger.w('User profile modal requested with empty uid');
      return;
    }

    final List<String> members = <String>[
      auth.currentUser?.uid ?? '',
      profile?.flMeta?.id ?? '',
    ];

    final Relationship relationship = cacheController.getFromCache(members.asGUID) ?? Relationship.empty(members);
    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      child: ProfileModalDialog(profile: profile!, relationship: relationship),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String tagline = profile?.getTagline(localizations) ?? '';

    return PositiveTapBehaviour(
      onTap: profile == null ? () {} : () => profileController.viewProfile(profile!),
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
            PositiveProfileCircularIndicator(profile: profile, size: kIconHuge),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getSafeDisplayNameFromProfile(profile),
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
              onTapped: () => onOptionsTapped(context),
              isDisabled: !isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
