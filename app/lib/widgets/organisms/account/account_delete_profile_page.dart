// Flutter imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/services/third_party.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';
import 'package:logger/logger.dart';

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
      if (profile == null) {
        logger.e('No profile found');
        return;
      }

      final Set<String> visibilityFlags = profile.visibilityFlags;
      if (visibilityFlags.contains(kFeatureFlagPendingDeletion)) {
        logger.i('Profile already pending deletion');
        return;
      }

      await profileApiService.updateVisibilityFlags(visibilityFlags: visibilityFlags..add(kFeatureFlagPendingDeletion));
      await appRouter.pop();
    } finally {
      isDeleting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PositiveGenericPage(
      title: 'We are sorry to see you go',
      body: 'but we under why. We ask you to verify some of your details just to be sure it\'s you trying to delete your account.',
      buttonText: 'Get Started',
      isBusy: isDeleting,
      onContinueSelected: onContinueSelected,
    );
  }
}
