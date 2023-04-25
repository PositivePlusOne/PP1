// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';
import '../main.dart';

class AuthProviderGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.state.user;

    if (user == null) {
      resolver.next(true);
      return;
    }

    if (!userController.isPasswordProviderLinked) {
      final AccountFormController newAccountFormController = providerContainer.read(accountFormControllerProvider.notifier);
      if (user.email != null) {
        newAccountFormController.onEmailAddressChanged(user.email!);
      }

      router.removeWhere((route) => true);
      router.push(const RegistrationEmailEntryRoute());
      resolver.next(false);
      return;
    }

    if (!userController.isPhoneProviderLinked) {
      router.removeWhere((route) => true);
      router.push(const RegistrationPhoneEntryRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
