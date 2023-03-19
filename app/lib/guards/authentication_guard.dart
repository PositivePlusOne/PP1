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

    resolver.next(true);
  }
}
