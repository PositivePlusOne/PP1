// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';
import '../main.dart';

class AuthSetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.currentUser;

    if (user == null) {
      resolver.next(true);
      return;
    }

    if (userController.isSocialProviderLinked) {
      resolver.next(true);
      return;
    }

    if (!userController.isPasswordProviderLinked) {
      final Locale locale = Localizations.localeOf(router.navigatorKey.currentContext!);
      final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
      final AccountFormController controller = providerContainer.read(provider.notifier);
      if (user.email != null) {
        controller.onEmailAddressChanged(user.email!);
      }

      router.replaceAll([const RegistrationEmailEntryRoute()]);
      resolver.next(false);
      return;
    }

    // if (profileController.state.currentProfile?.phoneNumber.isEmpty ?? true) {
    //   router.removeWhere((route) => true);
    //   router.push(const RegistrationPhoneEntryRoute());
    //   resolver.next(false);
    //   return;
    // }

    resolver.next(true);
  }
}
