// Package imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/user_controller.dart';
import '../gen/app_router.dart';

class ProfileSetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final ProfileFormController profileFormController = providerContainer.read(profileFormControllerProvider.notifier);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);

    final User? user = userController.currentUser;

    // If the user is not logged in, carry on as normal
    if (user == null) {
      resolver.next(true);
      return;
    }

    final Profile? currentProfile = profileControllerState.currentProfile;
    final String currentUserId = user.uid;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    if (currentUserId != currentProfileId) {
      resolver.next(true);
      return;
    }

    final bool hasName = currentProfile?.name.isNotEmpty ?? false;
    if (!hasName) {
      profileFormController.resetState(FormMode.create);

      //   // Get the user's name from the user object if it exists
      //   if (user.providerName != null) {
      //     profileFormController.onNameChanged(user.providerName!);
      //   }

      router.removeWhere((route) => true);
      router.push(const RegistrationAccountSetupRoute());
      resolver.next(false);
      return;
    }

    final bool hasDisplayName = currentProfile?.displayName.isNotEmpty ?? false;
    if (!hasDisplayName) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileDisplayNameEntryRoute());
      resolver.next(false);
      return;
    }

    final bool hasBirthday = currentProfile?.birthday.isNotEmpty ?? false;
    if (!hasBirthday) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileBirthdayEntryRoute());
      resolver.next(false);
      return;
    }

    // final bool hasSetGender = currentProfile?.genders.isNotEmpty ?? false;
    // final bool hasGendersInState = genderControllerState.options.isNotEmpty;
    // if (!hasSetGender && hasGendersInState) {
    //   profileFormController.resetState(FormMode.create);
    //   router.removeWhere((route) => true);
    //   router.push(const ProfileGenderSelectRoute());
    //   resolver.next(false);
    //   return;
    // }

    // final bool hasSetHivStatus = currentProfile?.hivStatus.isNotEmpty ?? false;
    // final bool hasHivStatusInState = hivStatusController.state.hivStatuses.isNotEmpty;
    // if (!hasSetHivStatus && hasHivStatusInState) {
    //   profileFormController.resetState(FormMode.create);
    //   router.removeWhere((route) => true);
    //   router.push(const ProfileHivStatusRoute());
    //   resolver.next(false);
    //   return;
    // }

    // final bool hasInterests = currentProfile?.interests.isNotEmpty ?? false;
    // final bool hasInterestsInState = interestsControllerState.interests.isNotEmpty;
    // if (!hasInterests && hasInterestsInState) {
    //   profileFormController.resetState(FormMode.create);
    //   router.removeWhere((route) => true);
    //   router.push(const ProfileInterestsEntryRoute());
    //   resolver.next(false);
    //   return;
    // }

    // final PositivePlace? place = currentProfile?.place;
    // final bool hasLocation = place != null && (place.optOut || place.placeId.isNotEmpty);
    // if (!hasLocation) {
    //   profileFormController.resetState(FormMode.create);
    //   router.removeWhere((route) => true);
    //   router.push(const ProfileLocationRoute());
    //   resolver.next(false);
    //   return;
    // }

    final bool hasProfileReferenceImage = currentProfile?.referenceImage != null;
    if (!hasProfileReferenceImage) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfileReferenceImageWelcomeRoute());
      resolver.next(false);
      return;
    }

    final bool hasProfileImage = currentProfile?.profileImage != null;
    if (!hasProfileImage) {
      profileFormController.resetState(FormMode.create);
      router.removeWhere((route) => true);
      router.push(const ProfilePhotoSelectionRoute());
      resolver.next(false);
      return;
    }

    final bool hasAccentColor = currentProfile?.accentColor.isNotEmpty ?? false;
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
