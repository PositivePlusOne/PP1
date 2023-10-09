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
    localizations.page_onboarding_terms_interests_how_we_use,
    [
      localizations.page_onboarding_terms_interests_one,
      localizations.page_onboarding_terms_interests_two,
    ],
  );
}

HintDialogRoute buildProfileGenderHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_identity_how_we_use,
    [
      localisations.page_onboarding_terms_identity_one,
      localisations.page_onboarding_terms_identity_two,
      localisations.page_onboarding_terms_identity_three,
    ],
  );
}

HintDialogRoute buildProfileLocationHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_onboarding_terms_interests_how_we_use,
    [
      localizations.page_onboarding_terms_location_one,
      localizations.page_onboarding_terms_location_two,
    ],
  );
}

HintDialogRoute buildProfileHivStatusHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_hiv_how_we_use,
    [
      localisations.page_onboarding_terms_hiv_one,
      localisations.page_onboarding_terms_hiv_two,
      localisations.page_onboarding_terms_hiv_three,
      localisations.page_onboarding_terms_hiv_four,
    ],
  );
}

HintDialogRoute buildProfileCompanySectorsHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_company_sectors_how_we_use,
    [
      localisations.page_onboarding_terms_company_sectors_one,
      localisations.page_onboarding_terms_company_sectors_two,
      localisations.page_onboarding_terms_company_sectors_three,
    ],
  );
}

HintDialogRoute buildProfileBirthdayHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_birthday_how_we_use,
    [
      localisations.page_onboarding_terms_birthday_one,
      localisations.page_onboarding_terms_birthday_two,
      localisations.page_onboarding_terms_birthday_three,
      localisations.page_onboarding_terms_birthday_four,
      localisations.page_onboarding_terms_birthday_five,
    ],
  );
}

HintDialogRoute buildProfileDisplayNameHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    "What is your display name",
    [
      "Your display name is how you are identified to us and other people across Positive+1",
      "It keeps you unique and can be anything you like (within reason)",
      "We have some small rules: No profanity or at risk terms",
    ],
  );
}

HintDialogRoute buildProfileNameHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    "What your name is used for",
    [
      "Your name is stored against your account for security purposes",
      "You can choose to display your name within the app to other people",
      "You can change this setting at any time based on your personal preferences",
    ],
  );
}

HintDialogRoute buildReferencePhotoHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    "copy goes here",
    [""],
  );
}

HintDialogRoute buildProfilePhotoHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_reference_how_we_use,
    [
      localisations.page_onboarding_terms_reference_one,
      localisations.page_onboarding_terms_reference_two,
    ],
  );
}

HintDialogRoute buildAccountPhoneHint(BuildContext context) {
  final AppLocalizations localisations = AppLocalizations.of(context)!;
  return fromTitleAndBulletPoints(
    localisations.page_onboarding_terms_number_how_we_use,
    [
      localisations.page_onboarding_terms_number_one,
      localisations.page_onboarding_terms_number_two,
      localisations.page_onboarding_terms_number_three,
      localisations.page_onboarding_terms_number_four,
    ],
    trailingText: localisations.page_onboarding_terms_trust,
  );
}

HintDialogRoute fromTitleAndBulletPoints(String title, List<String> bulletPoints, {String? trailingText}) {
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
              text: Text(e, style: typography.styleSubtitle.copyWith(color: colors.white)),
            ),
          )
          .toList()
          .spaceWithVertical(kPaddingSmall),
      if (trailingText != null) ...[
        const SizedBox(height: kPaddingMedium),
        Text(
          trailingText,
          style: typography.styleHero.copyWith(color: colors.red),
        ),
      ]
    ],
  );
}
