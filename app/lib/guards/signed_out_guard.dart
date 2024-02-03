// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/providers/user/user_controller.dart';
import '../main.dart';

class SignedOutGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.currentUser;

    if (user != null) {
      router.removeWhere((route) => true);
      router.push(kDefaultRoute);
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
