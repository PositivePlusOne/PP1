// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class LoginWelcomeBackPage extends ConsumerWidget {
  const LoginWelcomeBackPage({super.key});

  List<String> getWelcomeBackMessages(AppLocalizations localisations) {
    return [
      localisations.page_welcome_back_message_one,
      localisations.page_welcome_back_message_two,
      localisations.page_welcome_back_message_three,
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel viewModel = ref.read(loginViewModelProvider.notifier);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    List<String> welcomeBackMessages = getWelcomeBackMessages(localisations);
    int randomIndex = Random().nextInt(welcomeBackMessages.length);

    return PositiveGenericPage(
      title: localisations.page_welcome_back_title.toUpperCase(),
      body: welcomeBackMessages[randomIndex],
      buttonText: localisations.shared_actions_sign_in,
      onContinueSelected: viewModel.onWelcomeBackContinueSelected,
    );
  }
}
