// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

class LoginWelcomeBackPage extends ConsumerWidget {
  const LoginWelcomeBackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel viewModel = ref.read(loginViewModelProvider.notifier);

    return PositiveGenericPage(
      title: 'Welcome Back',
      body: 'You can now return to the Positive+1 App.',
      buttonText: 'Return to Positive+1',
      onContinueSelected: viewModel.onWelcomeBackContinueSelected,
    );
  }
}
