// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class ProfileDeleteAccountPage extends ConsumerWidget {
  const ProfileDeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final UserControllerState userControllerState = ref.watch(userControllerProvider);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveGenericPage(
      title: localizations.page_profile_delete_account_title,
      body: localizations.page_profile_delete_account_body,
      style: PositiveGenericPageStyle.decorated,
      buttonText: localizations.shared_actions_continue_to_positive_plus_one,
      isBusy: userControllerState.isBusy,
      onContinueSelected: userController.deleteAccount,
      canBack: true,
      currentStepIndex: 2,
      totalSteps: 9,
    );
  }
}
