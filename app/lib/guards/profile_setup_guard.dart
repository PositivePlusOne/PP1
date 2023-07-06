// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/extensions/user_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/gender_controller.dart';
import 'package:app/providers/content/hiv_status_controller.dart';
import 'package:app/providers/content/interests_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';

class ProfileSetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final InterestsControllerState interestsControllerState = providerContainer.read(interestsControllerProvider);
    final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);
    final ProfileFormController profileFormController = providerContainer.read(profileFormControllerProvider.notifier);
    final HivStatusController hivStatusController = providerContainer.read(hivStatusControllerProvider.notifier);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);

    final User? user = userController.currentUser;
    final bool hasProfile = profileController.currentProfile != null;

    // If the user is not logged in, carry on as normal
    if (user == null) {
      resolver.next(true);
      return;
    }

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (!hasProfile) {
      router.removeWhere((route) => true);
      router.push(const RegistrationAccountSetupRoute());
      resolver.next(false);
      return;
    }

    final bool hasName = profileController.currentProfile?.name.isNotEmpty ?? false;
    if (!hasName) {
      profileFormController.resetState(FormMode.create);

      // Get the user's name from the user object if it exists
      if (user.providerName != null) {
        profileFormController.onNameChanged(user.providerName!);
      }

      router.removeWhere((route) => true);
      router.push(const ProfileNameEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasDisplayName = profileController.currentProfile?.displayName.isNotEmpty ?? false;
    if (!hasDisplayName) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileDisplayNameEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasBirthday = profileController.currentProfile?.birthday.isNotEmpty ?? false;
    if (!hasBirthday) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileBirthdayEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasSetGender = profileController.currentProfile?.genders.isNotEmpty ?? false;
    final bool hasGendersInState = genderControllerState.options.isNotEmpty;
    if (!hasSetGender && hasGendersInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileGenderSelectRoute());
      resolver.next(false);
      return;
    }

    final bool hasSetHivStatus = profileController.currentProfile?.hivStatus.isNotEmpty ?? false;
    final bool hasHivStatusInState = hivStatusController.state.hivStatuses.isNotEmpty;
    if (!hasSetHivStatus && hasHivStatusInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileHivStatusRoute());
      resolver.next(false);
      return;
    }

    final bool hasInterests = profileController.currentProfile?.interests.isNotEmpty ?? false;
    final bool hasInterestsInState = interestsControllerState.interests.isNotEmpty;
    if (!hasInterests && hasInterestsInState) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileInterestsEntryRoute());
      resolver.next(false);
      return;
    }

    final PositivePlace? place = profileController.currentProfile?.place;
    final bool hasLocation = place != null && (place.optOut || place.placeId.isNotEmpty);
    if (!hasLocation) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileLocationRoute());
      resolver.next(false);
      return;
    }

    final bool hasProfileReferenceImage = profileController.currentProfile?.referenceImage.isNotEmpty ?? false;
    if (!hasProfileReferenceImage) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileReferenceImageWelcomeRoute());
      resolver.next(false);
      return;
    }

    final bool hasProfileImage = profileController.currentProfile?.profileImage.isNotEmpty ?? false;
    if (!hasProfileImage) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfilePhotoSelectionRoute());
      resolver.next(false);
      return;
    }

    final bool hasAccentColor = profileController.currentProfile?.accentColor.isNotEmpty ?? false;
    if (!hasAccentColor) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileBiographyEntryRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
