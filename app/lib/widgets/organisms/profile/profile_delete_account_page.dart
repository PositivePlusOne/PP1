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
class ProfileDeleteAccountPage extends ConsumerStatefulWidget {
  const ProfileDeleteAccountPage({super.key});

  @override
  ConsumerState<ProfileDeleteAccountPage> createState() => _ProfileDeleteAccountPageState();
}

class _ProfileDeleteAccountPageState extends ConsumerState<ProfileDeleteAccountPage> {
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
      final UserController userController = ref.read(userControllerProvider.notifier);
      userController.deleteAccount();
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
      style: PositiveGenericPageStyle.decorated,
      buttonText: localizations.shared_actions_continue_to_positive_plus_one,
      onContinueSelected: onDeleteAccountSelected,
      isBusy: isDeleting,
      canBack: true,
      currentStepIndex: 2,
      totalSteps: 9,
    );
  }
}
