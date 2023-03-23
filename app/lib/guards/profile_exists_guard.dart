// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../gen/app_router.dart';

class ProfileExistsGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

    final bool hasProfile = profileControllerState.userProfile != null;

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (!hasProfile) {
      router.removeWhere((route) => true);
      router.push(const HomeRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
