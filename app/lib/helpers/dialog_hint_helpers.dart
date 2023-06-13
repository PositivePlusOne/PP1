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
  return fromTitleAndBulletPoints(
    "Your HIV Status",
    [
      "This is a community for people living with, working in, and affected by HIV. To create a safe and open environment it is important that each of us shares our HIV status",
      "Positive+1 will not share your HIV status outside of the platform",
      "If you need to change your HIV status at a later date you can do this via your Profile",
    ],
  );
}

HintDialogRoute buildProfileBirthdayHint(BuildContext context) {
  return fromTitleAndBulletPoints(
    "Why we need your birthday",
    [
      "We use this to identify you",
      "We can tailor content to your age",
      "The app can restrict access to content due to your age",
      "You can choose to present your age and birthday to other users",
      "You will have to request to change this at a later date if you input this incorrectly",
    ],
  );
}

HintDialogRoute buildProfileDisplayNameHint(BuildContext context) {
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
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  return fromTitleAndBulletPoints(
    "What your name is used for",
    ["Your name is stored against your account for security purposes", "You can choose to display your name within the app to other people", "You can change this setting at any time based on your personal preferences"],
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
  return fromTitleAndBulletPoints(
    'How we use your number',
    [
      'Your number will never be displayed to other users.',
      'Your number will never be used to send marketing messages to.',
      'Your mobile number will be used to send you an account verification code.',
      'Your account verification code connects your mobile number, to your account, to your mobile device.',
    ],
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
