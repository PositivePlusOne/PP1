// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class AccountDeleteProfilePage extends ConsumerWidget {
  const AccountDeleteProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final UserControllerState userControllerState = ref.watch(userControllerProvider);

    return PositiveGenericPage(
      title: 'We are sorry to see you go',
      body: 'but we under why. We ask you to verify some of your details just to be sure it\'s you trying to delete your account.',
      buttonText: 'Get Started',
      isBusy: userControllerState.isBusy,
      onContinueSelected: userController.deleteAccount,
    );
  }
}
