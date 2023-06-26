// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
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
    isDeleting = true;

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.deleteAccount();
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
