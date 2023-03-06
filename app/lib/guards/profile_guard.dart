// Package imports:
import 'package:app/widgets/organisms/profile/profile_image_welcome_page.dart';
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';

class ProfileGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final UserControllerState userControllerState = providerContainer.read(userControllerProvider);

    final bool hasProfile = profileControllerState.userProfile != null;
    final bool isLoggedIn = userControllerState.user != null;

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (isLoggedIn && !hasProfile) {
      router.removeWhere((route) => true);
      router.push(const RegistrationAccountSetupRoute());
      resolver.next(false);
      return;
    }

    final bool hasProfileReferenceImage = profileControllerState.userProfile?.referenceImageUrl.isNotEmpty ?? false;

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (isLoggedIn && !hasProfileReferenceImage) {
      router.removeWhere((route) => true);
      router.push(const ProfileImageWelcomeRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
