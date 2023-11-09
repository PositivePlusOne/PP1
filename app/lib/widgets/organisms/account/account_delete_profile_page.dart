// Flutter imports:
import 'package:app/helpers/dialog_hint_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class AccountDeleteProfilePage extends ConsumerStatefulWidget {
  const AccountDeleteProfilePage({super.key});

  @override
  ConsumerState<AccountDeleteProfilePage> createState() => _AccountDeleteProfilePageState();
}

class _AccountDeleteProfilePageState extends ConsumerState<AccountDeleteProfilePage> {
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  set isDeleting(bool value) {
    _isDeleting = value;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onContinueSelected() async {
    final Logger logger = ref.read(loggerProvider);
    isDeleting = true;

    try {
      logger.i('Deleting profile');
      final AppRouter appRouter = ref.read(appRouterProvider);
      final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);

      final Profile? profile = profileController.currentProfile;
      final String profileId = profile?.flMeta?.id ?? '';
      if (profileId.isEmpty || profile == null) {
        logger.e('No profile found');
        return;
      }

      final Set<String> accountFlags = profile.accountFlags;
      if (accountFlags.contains(kFeatureFlagPendingDeletion)) {
        logger.i('Profile already pending deletion');
        return;
      }

      await profileApiService.toggleProfileDeletion(uid: profileId);
      appRouter.popUntil((route) => route.settings.name == AccountDetailsRoute.name);
    } finally {
      isDeleting = false;
    }
  }

  Future<void> onHelpRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    logger.i('Requesting delete profile help');
    final hint = fromTitleAndBulletPoints(
      localisations.page_account_actions_change_delete_account_body,
      [
        localisations.page_account_actions_change_delete_account_body_one,
        localisations.page_account_actions_change_delete_account_body_two,
        localisations.page_account_actions_change_delete_account_body_three,
        localisations.page_account_actions_change_delete_account_body_four,
        localisations.page_account_actions_change_delete_account_body_five,
        localisations.page_account_actions_change_delete_account_body_six,
        localisations.page_account_actions_change_delete_account_body_seven,
      ],
      boldFootnote: localisations.page_account_actions_change_delete_account_body_eight,
    );
    await appRouter.push(hint);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return PositiveGenericPage(
      title: localizations.page_account_actions_change_delete_account_splash_title,
      body: localizations.page_account_actions_change_delete_account_splash_body,
      buttonText: localizations.page_account_actions_change_delete_account_continue,
      isBusy: isDeleting,
      onHelpSelected: onHelpRequested,
      onContinueSelected: onContinueSelected,
    );
  }
}
