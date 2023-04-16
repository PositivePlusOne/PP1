// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/extensions/widget_extensions.dart';
import '../constants/design_constants.dart';
import '../dtos/system/design_colors_model.dart';
import '../dtos/system/design_typography_model.dart';
import '../gen/app_router.dart';
import '../main.dart';
import '../providers/system/design_controller.dart';
import '../widgets/atoms/typography/positive_bulleted_text.dart';

HintDialogRoute buildProfileInterestsHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_interests_hint_title,
    [
      localizations.page_profile_interests_hint_bullet_one,
    ],
  );
}

HintDialogRoute buildProfileGenderHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_gender_hint_title,
    [
      localizations.page_profile_gender_hint_bullet_one,
    ],
  );
}

HintDialogRoute buildProfileLocationHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_location_hint_title,
    [
      localizations.page_profile_location_hint_bullet_one,
      localizations.page_profile_location_hint_bullet_two,
    ],
  );
}

HintDialogRoute buildProfileHivStatusHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_hiv_status_hint_title,
    [
      localizations.page_profile_hiv_status_hint_bullet_one,
      localizations.page_profile_hiv_status_hint_bullet_two,
      localizations.page_profile_hiv_status_hint_bullet_three,
    ],
  );
}

HintDialogRoute buildProfileBirthdayHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_birthday_hint_title,
    [
      localizations.page_profile_birthday_hint_bullet_one,
      localizations.page_profile_birthday_hint_bullet_two,
      localizations.page_profile_birthday_hint_bullet_three,
      localizations.page_profile_birthday_hint_bullet_four,
      localizations.page_profile_birthday_hint_bullet_five,
    ],
  );
}

HintDialogRoute buildProfileDisplayNameHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_display_name_hint_title,
    [
      localizations.page_profile_display_name_hint_bullet_one,
      localizations.page_profile_display_name_hint_bullet_two,
      localizations.page_profile_display_name_hint_bullet_three,
    ],
  );
}

HintDialogRoute buildProfileNameHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_profile_name_hint_title,
    [
      localizations.page_profile_name_hint_bullet_one,
      localizations.page_profile_name_hint_bullet_two,
      localizations.page_profile_name_hint_bullet_three,
    ],
  );
}

HintDialogRoute buildReferencePhotoHint(BuildContext context) {
  // final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    "copy goes here",
    [""],
  );
}

HintDialogRoute buildProfilePhotoHint(BuildContext context) {
  // final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    "copy goes here",
    [""],
  );
}

HintDialogRoute buildAccountPhoneHint(BuildContext context) {
  // final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    'Why we need your phone number',
    ['TBC'],
  );
}

HintDialogRoute fromTitleAndBulletPoints(String title, List<String> bulletPoints) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

  return HintDialogRoute(
    widgets: <Widget>[
      Text(
        title,
        style: typography.styleHero.copyWith(color: colors.red),
      ),
      const SizedBox(height: kPaddingMedium),
      ...bulletPoints
          .map(
            (e) => PositiveBulletedText(
              text: Text(e, style: typography.styleSubtitle.copyWith(color: colors.red)),
            ),
          )
          .toList()
          .spaceWithVertical(kPaddingSmall),
    ],
  );
}
