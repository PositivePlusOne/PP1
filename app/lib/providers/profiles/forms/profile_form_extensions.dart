// ignore_for_file: invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/services/third_party.dart';

extension ProfileFormExtensions on ProfileFormController {
  Future<void> onProfileDisplayNameConfirmed(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    if (!isDisplayNameValid) {
      return;
    }

    state = state.copyWith(isBusy: true);
    logger.i('Saving display name: ${state.displayName}');

    try {
      await profileController.updateDisplayName(state.displayName);
      logger.i('Successfully saved display name: ${state.displayName}');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          await appRouter.replaceAll([const HomeRoute()]);
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(
            title: localisations.page_profile_name_entry_description_updated_title,
            continueText: localisations.page_account_actions_change_return_account,
            body: localisations.page_profile_name_entry_description_updated_body,
          ));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDisplayNameAndNameConfirmed(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile? currentProfile = profileController.currentProfile;

    if (!isDisplayNameValid || !isNameValid) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);
      logger.i('Saving display name and name: ${state.displayName}');

      final Set<String> currentVisibilityFlags = currentProfile?.visibilityFlags ?? {};

      final bool requiresNameUpdate = currentProfile?.name != state.name;
      if (requiresNameUpdate) {
        await profileController.updateName(state.name, currentVisibilityFlags);
      }

      final bool requiresDisplayNameUpdate = currentProfile?.displayName != state.displayName;
      if (requiresDisplayNameUpdate) {
        await profileController.updateDisplayName(state.displayName);
      }

      logger.i('Successfully saved display name and name: ${state.displayName}');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          await appRouter.replaceAll([const HomeRoute()]);
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(
            title: 'Your profile has been updated',
            continueText: 'Return to your account',
            body: 'Your profile has been updated',
          ));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
