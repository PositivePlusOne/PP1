// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/gender_controller.dart';
import 'package:app/providers/content/hiv_status_controller.dart';
import 'package:app/providers/content/interests_controller.dart';
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
    final InterestsControllerState interestsControllerState = providerContainer.read(interestsControllerProvider);
    final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);
    final ProfileFormController profileFormController = providerContainer.read(profileFormControllerProvider.notifier);
    final HivStatusController hivStatusController = providerContainer.read(hivStatusControllerProvider.notifier);

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

    final bool hasSetGender = profileControllerState.userProfile?.genders.isNotEmpty ?? false;
    final bool hasGendersInState = genderControllerState.options.isNotEmpty;
    if (isLoggedIn && !hasSetGender && hasGendersInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileGenderSelectRoute());
      resolver.next(false);
      return;
    }

    final bool hasSetHivStatus = profileControllerState.userProfile?.hivStatus.isNotEmpty ?? false;
    final bool hasHivStatusInState = hivStatusController.state.hivStatuses.isNotEmpty;
    if (isLoggedIn && !hasSetHivStatus && hasHivStatusInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileHivStatusRoute());
      resolver.next(false);
      return;
    }

    final bool hasLocation = false;
    if (isLoggedIn && !hasLocation) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileLocationRoute());
      resolver.next(false);
      return;
    }

    final bool hasInterests = profileControllerState.userProfile?.interests.isNotEmpty ?? false;
    final bool hasInterestsInState = interestsControllerState.interests.isNotEmpty;
    if (isLoggedIn && !hasInterests && hasInterestsInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileInterestsEntryRoute());
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
