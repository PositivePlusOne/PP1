// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/widgets.dart';
import '../gen/app_router.dart';

class SecurityGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final Profile? currentProfile = profileControllerState.currentProfile;

    if (currentProfile == null) {
      resolver.next(true);
      return;
    }

    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final bool isBanned = currentProfile.isBanned;
    if (isBanned) {
      final String errorTitle = localizations.shared_errors_account_terminated;
      String errorDescription = '';
      if (currentProfile.banReason.isNotEmpty) {
        errorDescription = localizations.shared_errors_account_terminated_description(currentProfile.banReason);
      }

      router.replaceAll([
        ErrorRoute(
          errorMessage: errorTitle,
          errorExplanation: errorDescription,
          shouldSignOutOnContinue: true,
        )
      ]);

      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
