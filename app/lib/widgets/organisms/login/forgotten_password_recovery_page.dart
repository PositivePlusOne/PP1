// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class ForgottenPasswordRecoveryPage extends ConsumerStatefulWidget {
  const ForgottenPasswordRecoveryPage({super.key});

  @override
  ConsumerState<ForgottenPasswordRecoveryPage> createState() => _ForgottenPasswordRecoveryPageState();
}

class _ForgottenPasswordRecoveryPageState extends ConsumerState<ForgottenPasswordRecoveryPage> {
  Future<void> onContinueSelected(LoginViewModel viewModel) async {
    // show the email client so they can recover then please
    viewModel.onAccountRecoveryShowEmailClientSelected(context);
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = ref.watch(loginViewModelProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return PositiveGenericPage(
      title: localizations.page_registration_forgotten_password_recovery,
      body: localizations.page_registration_forgotten_password_recovery_body,
      canBack: true,
      primaryActionText: localizations.page_registration_forgotten_password_recovery_button,
      onPrimaryActionSelected: () => onContinueSelected(viewModel),
    );
  }
}
