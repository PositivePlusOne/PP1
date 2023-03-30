// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/profile_form_controller.dart';
import '../shared/positive_generic_page.dart';

class ProfileWelcomeBackPage extends ConsumerWidget {
  const ProfileWelcomeBackPage({
    required this.nextPage,
    super.key,
  });

  final PageRouteInfo nextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileFormController viewModel = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    return PositiveGenericPage(
      title: 'Welcome Back',
      body: 'To continue with your registration, please press continue below',
      buttonText: 'Continue',
      isBusy: state.isBusy,
      style: PositiveGenericPageStyle.decorated,
      onContinueSelected: () => viewModel.onProfileSetupContinueSelected(nextPage),
    );
  }
}
