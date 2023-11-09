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
    ],
  );
}

HintDialogRoute buildProfileLocationHint(BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    localizations.page_onboarding_terms_location_how_we_use,
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

HintDialogRoute fromTitleAndBulletPoints(String title, List<String> bulletPoints, {String? trailingText, String? boldFootnote}) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

  return HintDialogRoute(
    widgets: <Widget>[
      Text(
        title,
        style: typography.styleHero.copyWith(color: colors.white),
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
      if (boldFootnote != null) ...[
        const SizedBox(height: kPaddingMedium),
        Text(
          boldFootnote,
          style: typography.styleSubtitle.copyWith(color: colors.white, fontWeight: FontWeight.bold),
        ),
      ],
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
