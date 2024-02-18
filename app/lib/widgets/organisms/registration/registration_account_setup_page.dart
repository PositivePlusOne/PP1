// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../shared/positive_generic_page.dart';

@RoutePage()
class RegistrationAccountSetupPage extends ConsumerWidget {
  const RegistrationAccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);
    final RegistrationAccountViewModelState state = ref.watch(registrationAccountViewModelProvider);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveGenericPage(
      title: localizations.page_registration_account_setup,
      body: localizations.page_registration_account_setup_body,
      isBusy: state.isBusy,
      primaryActionText: localizations.page_registration_account_setup_continue,
      onPrimaryActionSelected: viewModel.onCreateProfileSelected,
    );
  }
}
