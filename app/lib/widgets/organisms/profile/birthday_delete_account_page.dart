// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class BirthdayDeleteAccountPage extends ConsumerStatefulWidget {
  const BirthdayDeleteAccountPage({super.key});

  @override
  ConsumerState<BirthdayDeleteAccountPage> createState() => _BirthdayDeleteAccountPageState();
}

class _BirthdayDeleteAccountPageState extends ConsumerState<BirthdayDeleteAccountPage> {
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  set isDeleting(bool value) {
    _isDeleting = value;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onDeleteAccountSelected() async {
    isDeleting = true;

    try {
      final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
      final Profile? profile = profileController.currentProfile;
      final String currentProfileId = profile?.flMeta?.id ?? '';

      final accountFlags = profile?.accountFlags ?? <String>{};
      if (!accountFlags.contains(kFeatureFlagPendingDeletion)) {
        await analyticsController.trackEvent(AnalyticEvents.accountDeletionRequested);
        await profileApiService.toggleProfileDeletion(uid: currentProfileId);
      }

      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.signOut(shouldNavigate: true);
    } finally {
      isDeleting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveGenericPage(
      title: localizations.page_profile_delete_account_title,
      body: localizations.page_profile_delete_account_body,
      primaryActionText: localizations.shared_actions_continue_to_positive_plus_one,
      onPrimaryActionSelected: onDeleteAccountSelected,
      isBusy: isDeleting,
      canBack: true,
      currentStepIndex: 2,
      totalSteps: 9,
    );
  }
}
