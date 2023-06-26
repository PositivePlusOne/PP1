// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import '../main.dart';

class SignedInGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.currentUser;

    if (user == null) {
      resolver.next(false);
      router.push(const HomeRoute());
      return;
    }

    resolver.next(true);
  }
}
