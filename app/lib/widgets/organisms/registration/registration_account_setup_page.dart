// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../shared/positive_breather_page_template.dart';

class RegistrationAccountSetupPage extends ConsumerWidget {
  const RegistrationAccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);
    final RegistrationAccountViewModelState state = ref.watch(registrationAccountViewModelProvider);

    return PositiveBreatherPageTemplate(
      title: 'Account Setup!',
      body: 'Let’s take a breather, from here we will ask for you to complete your profile before you can access Positive+1',
      buttonText: 'Let\'s Continue',
      isBusy: state.isBusy,
      onContinueSelected: viewModel.onCreateProfileSelected,
    );
  }
}
