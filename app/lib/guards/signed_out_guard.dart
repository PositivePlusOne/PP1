// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import '../constants/router_constants.dart';
import '../main.dart';

class SignedOutGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.state.user;

    if (user != null) {
      router.removeWhere((route) => true);
      router.push(kDefaultRoute);
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
