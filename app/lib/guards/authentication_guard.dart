// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';
import '../main.dart';

class AuthenticationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.state.user;

    if (user == null) {
      router.removeWhere((route) => true);
      router.push(const HomeRoute());
      resolver.next(false);
      return;
    }

    if (!userController.isPasswordProviderLinked) {
      router.removeWhere((route) => true);
      router.push(const RegistrationEmailEntryRoute());
      resolver.next(false);
      return;
    }

    if (!userController.isPhoneProviderLinked && (userController.state.phoneVerificationId?.isNotEmpty ?? false)) {
      router.removeWhere((route) => true);
      router.push(const RegistrationPhoneVerificationRoute());
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
