// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

class AccountDeleteProfilePage extends ConsumerWidget {
  const AccountDeleteProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);
    final AccountFormState accountFormState = ref.watch(accountFormControllerProvider);

    return PositiveGenericPage(
      title: 'We are sorry to see you go',
      body: 'but we under why. We ask you to verify some of your details just to be sure it\'s you trying to delete your account.',
      buttonText: 'Get Started',
      isBusy: accountFormState.isBusy,
      onContinueSelected: () => accountFormController.onVerificationRequested(),
    );
  }
}
