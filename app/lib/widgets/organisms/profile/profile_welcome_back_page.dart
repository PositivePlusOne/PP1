// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/profiles/profile_form_controller.dart';
import '../shared/positive_generic_page.dart';

@RoutePage()
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
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveGenericPage(
      title: localizations.page_registration_welcome_back,
      body: localizations.page_registration_welcome_back_body,
      isBusy: state.isBusy,
      primaryActionText: localizations.shared_actions_continue,
      onPrimaryActionSelected: () => viewModel.onProfileSetupContinueSelected(nextPage),
    );
  }
}
