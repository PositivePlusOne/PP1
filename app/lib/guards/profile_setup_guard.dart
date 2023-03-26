// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/main.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';

class ProfileSetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final UserControllerState userControllerState = providerContainer.read(userControllerProvider);
    final ProfileFormController profileFormController = providerContainer.read(profileFormControllerProvider.notifier);

    final bool hasProfile = profileControllerState.userProfile != null;
    final bool isLoggedIn = userControllerState.user != null;

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (isLoggedIn && !hasProfile) {
      router.removeWhere((route) => true);
      router.push(const RegistrationAccountSetupRoute());
      resolver.next(false);
      return;
    }

    final bool hasName = profileControllerState.userProfile?.name.isNotEmpty ?? false;
    if (isLoggedIn && !hasName) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileNameEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasDisplayName = profileControllerState.userProfile?.displayName.isNotEmpty ?? false;
    if (isLoggedIn && !hasDisplayName) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileDisplayNameEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasBirthday = profileControllerState.userProfile?.birthday.isNotEmpty ?? false;
    if (isLoggedIn && !hasBirthday) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileBirthdayEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasProfileReferenceImage = profileControllerState.userProfile?.hasReferenceImages ?? false;
    if (isLoggedIn && !hasProfileReferenceImage) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileImageWelcomeRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
