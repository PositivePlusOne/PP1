// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

// Flutter imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../services/third_party.dart';

part 'profile_controller.freezed.dart';
part 'profile_controller.g.dart';

@freezed
class ProfileControllerState with _$ProfileControllerState {
  const factory ProfileControllerState({
    @Default('') String currentProfileId,
    @Default({}) Set<String> availableProfileIds,
  }) = _ProfileControllerState;

  factory ProfileControllerState.initialState() => const ProfileControllerState(
        currentProfileId: '',
        availableProfileIds: {},
      );
}

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  StreamSubscription<User?>? userStreamSubscription;

  Profile? get currentProfile {
    if (state.currentProfileId.isEmpty) {
      return null;
    }

    return state.availableProfileIds.map((String id) => ref.read(cacheControllerProvider.notifier).getFromCache<Profile>(id)).firstWhere((Profile? profile) => profile?.id == state.currentProfileId, orElse: () => null);
  }

  bool get isCurrentlyAuthenticatedUser {
    if (currentProfile?.flMeta?.id?.isEmpty ?? true) {
      return false;
    }

    return currentProfile?.flMeta?.id == ref.read(firebaseAuthProvider).currentUser?.uid;
  }

  bool get isCurrentlyOrganisation {
    return currentProfile?.featureFlags.contains(kFeatureFlagOrganisationControls) ?? false;
  }

  bool get hasSetupProfile {
    if (!isCurrentlyAuthenticatedUser) {
      return true;
    }

    // TODO(ryan): This check should probably be better than are we missing this string
    return currentProfile?.accentColor.isNotEmpty ?? false;
  }

  @override
  ProfileControllerState build() {
    return ProfileControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    logger.i('[Profile Service] - Setting up listeners');
    await userStreamSubscription?.cancel();
    userStreamSubscription = firebaseAuth.authStateChanges().listen(onAuthenticatedUserChanged);
  }

  Future<void> onAuthenticatedUserChanged(User? user) async {
    final Logger logger = ref.read(loggerProvider);

    // The users profiles are preloaded by the call to system, so we only need to wipe the state if the user is null
    if (user == null) {
      logger.i('[Profile Service] - Authenticated user changed to null, resetting state');
      resetState();
      return;
    }
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Resetting');

    state = ProfileControllerState.initialState();
    providerContainer.read(eventBusProvider).fire(const ProfileSwitchedEvent(''));
  }

  void switchUser({String uid = ''}) {
    final Logger logger = ref.read(loggerProvider);

    logger.i('[Profile Service] - Switching user: $uid');
    if (uid.isNotEmpty && !state.availableProfileIds.contains(uid)) {
      throw Exception('Cannot switch to user that is not available - $uid');
    }

    state = state.copyWith(currentProfileId: uid);
    providerContainer.read(eventBusProvider).fire(ProfileSwitchedEvent(uid));
  }

  Future<void> viewProfile(Profile profile) async {
    final ProfileViewModel profileViewModel = ref.read(profileViewModelProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    final String id = profile.flMeta?.id ?? '';
    if (id.isEmpty) {
      logger.e('Profile has no id, cannot view profile: $profile');
      return;
    }

    await profileViewModel.preloadUserProfile(id);

    logger.i('Navigating to profile: ${profile.id}');
    await appRouter.push(const ProfileRoute());
  }

  Future<Profile> getProfile(String uid, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    logger.i('[Profile Service] - Loading profile: $uid');
    if (!skipCacheLookup) {
      final Profile? cachedProfile = cacheController.getFromCache(uid);
      if (cachedProfile != null) {
        logger.i('[Profile Service] - Profile loaded from cache: $uid');
        return cachedProfile;
      }
    }

    logger.i('[Profile Service] - Profile not found from repository or skipped, loading from firebase: $uid');
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-getProfile');
    final HttpsCallableResult response = await callable.call({
      'uid': uid,
    });

    logger.i('[Profile Service] - Profile loaded: $response');
    final Map<String, Object?> data = json.decodeSafe(response.data);
    if (data.isEmpty) {
      throw Exception('Profile not found');
    }

    logger.i('[Profile Service] - Profile parsed: $data');
    final Profile profile = Profile.fromJson(data);
    cacheController.addToCache(uid, profile);

    return profile;
  }

  Future<void> updateFirebaseMessagingToken() async {
    final NotificationsControllerState notificationControllerState = ref.read(notificationsControllerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = userController.currentUser;
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (currentProfile == null) {
      logger.w('[Profile Service] - Cannot update firebase messaging token without profile');
      return;
    }

    if (!notificationControllerState.remoteNotificationsInitialized) {
      logger.w('[Profile Service] - Cannot update firebase messaging token without remote notifications initialized');
      return;
    }

    if (user == null) {
      logger.e('[Profile Service] - Cannot update firebase messaging token without user');
      throw Exception('Cannot update firebase messaging token without user');
    }

    final String? firebaseMessagingToken = await ref.read(firebaseMessagingProvider).getToken();
    if (firebaseMessagingToken == null) {
      logger.e('[Profile Service] - Cannot update firebase messaging token without token');
      throw Exception('Cannot update firebase messaging token without token');
    }

    if (currentProfile?.fcmToken == firebaseMessagingToken) {
      logger.i('[Profile Service] - Firebase messaging token up to date');
      return;
    }

    await profileApiService.updateFcmToken(fcmToken: firebaseMessagingToken);
    analyticsController.trackEvent(AnalyticEvents.notificationFcmTokenUpdated, properties: {
      'fcmToken': firebaseMessagingToken,
    });
  }

  Future<void> updateEmailAddress({String? emailAddress}) async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = ref.read(firebaseAuthProvider).currentUser;
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (user == null || profileController.currentProfile == null) {
      logger.e('[Profile Service] - Cannot update email address without user or profile');
      return;
    }

    final String newEmailAddress = emailAddress ?? user.email ?? '';
    if (newEmailAddress.isEmpty) {
      logger.e('[Profile Service] - Cannot update email address without email address');
      return;
    }

    if (profileController.currentProfile?.email == newEmailAddress) {
      logger.i('[Profile Service] - Email address up to date');
      return;
    }

    await profileApiService.updateEmailAddress(emailAddress: newEmailAddress);
    logger.i('[Profile Service] - Email address updated');
  }

  Future<void> updatePhoneNumber({String? phoneNumber}) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    final User? user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update phone number without user');
      throw Exception('Cannot update phone number without user');
    }

    if (currentProfile == null) {
      logger.w('[Profile Service] - Cannot update phone number without profile');
      return;
    }

    final String actualPhoneNumber = phoneNumber ?? user.phoneNumber ?? '';
    if (actualPhoneNumber.isEmpty) {
      logger.e('[Profile Service] - Cannot update phone number without phone number');
      throw Exception('Cannot update phone number without phone number');
    }

    if (currentProfile?.phoneNumber == actualPhoneNumber) {
      logger.i('[Profile Service] - Phone number up to date');
      return;
    }

    await profileApiService.updatePhoneNumber(phoneNumber: actualPhoneNumber);
    logger.i('[Profile Service] - Phone number updated');
  }

  Future<void> updateName(String name, Set<String> visibilityFlags) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (currentProfile == null) {
      logger.w('[Profile Service] - Cannot update name without profile');
      return;
    }

    await profileApiService.updateName(
      name: name,
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updateDisplayName(String displayName) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (currentProfile == null) {
      logger.w('[Profile Service] - Cannot update display name without profile');
      return;
    }

    if (currentProfile?.displayName == displayName) {
      logger.i('[Profile Service] - Display name up to date');
      return;
    }

    await profileApiService.updateDisplayName(displayName: displayName);
  }

  Future<void> updateBirthday(String birthday, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update birthday without user');
      throw Exception('Cannot update birthday without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update birthday without profile');
      return;
    }

    if (state.userProfile?.birthday == birthday && state.userProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Birthday up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateBirthday');
    await callable.call(<String, dynamic>{
      'birthday': birthday,
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Birthday updated');
    final Profile profile = state.userProfile?.copyWith(birthday: birthday, visibilityFlags: visibilityFlags) ?? Profile.empty().copyWith(birthday: birthday, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateInterests(Set<String> interests, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update interests without user');
      throw Exception('Cannot update interests without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update interests without profile');
      return;
    }

    if (state.userProfile?.interests == interests && state.userProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Interests up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateInterests');
    await callable.call(<String, dynamic>{
      'interests': interests.toList(),
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Interests updated');
    final Profile profile = state.userProfile?.copyWith(interests: interests, visibilityFlags: visibilityFlags) ?? Profile.empty().copyWith(interests: interests, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateHivStatus(String status, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update hiv status without user');
      throw Exception('Cannot update hiv status without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update hiv status without profile');
      return;
    }

    if (state.userProfile?.hivStatus == status && state.userProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Hiv status up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateHivStatus');
    await callable.call(<String, dynamic>{
      'status': status,
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Status updated');
    final Profile profile = state.userProfile?.copyWith(hivStatus: status, visibilityFlags: visibilityFlags) ?? Profile.empty().copyWith(hivStatus: status, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateGenders(Set<String> genders, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update genders without user');
      throw Exception('Cannot update genders without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update genders without profile');
      return;
    }

    if (state.userProfile?.genders == genders && state.userProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Genders up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateGenders');
    await callable.call(<String, dynamic>{
      'genders': genders.toList(),
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Genders updated');
    final Profile profile = state.userProfile?.copyWith(genders: genders, visibilityFlags: visibilityFlags) ?? Profile.empty().copyWith(genders: genders, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updatePlace(PositivePlace? place, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update place without user');
      throw Exception('Cannot update place without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update place without profile');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updatePlace');
    await callable.call(<String, dynamic>{
      'optOut': place == null,
      'description': place?.description,
      'placeId': place?.placeId,
      'latitude': place?.latitude,
      'longitude': place?.longitude,
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Location updated');
    final Profile profile = state.userProfile!.copyWith(
      place: PositivePlace(description: place?.description ?? "", placeId: place?.placeId ?? ""),
      visibilityFlags: visibilityFlags,
    );

    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateReferenceImage(String imagePath) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final File picture = File(imagePath);

    final String base64String = await Isolate.run(() async {
      final Uint8List imageAsUint8List = await picture.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        return "";
      }

      final List<int> encodedJpg = img.encodeJpg(decodedImage);
      return base64Encode(encodedJpg);
    });

    if (base64String.isEmpty) {
      logger.w('[Profile Service] - Cannot update reference image without image');
      return;
    }

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update reference image without user');
      throw Exception('Cannot update reference image without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update reference image without profile');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateReferenceImage');
    await callable.call(<String, dynamic>{
      'referenceImage': base64String,
    });

    logger.i('[Profile Service] - Reference image updated');

    // We update the user profile to get a new image URL, and to reconfigure GetStream
    await updateUserProfile();
  }

  Future<void> updateProfileImage(String imagePath) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final File picture = File(imagePath);

    final String base64String = await Isolate.run(() async {
      final Uint8List imageAsUint8List = await picture.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        return "";
      }

      final List<int> encodedJpg = img.encodeJpg(decodedImage);
      return base64Encode(encodedJpg);
    });

    if (base64String.isEmpty) {
      logger.w('[Profile Service] - Cannot update profile image without image');
      return;
    }

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update profile image without user');
      throw Exception('Cannot update profile image without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update profile image without profile');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateProfileImage');
    await callable.call(<String, dynamic>{
      'profileImage': base64String,
    });

    logger.i('[Profile Service] - Profile image updated');

    // We update the user profile to get a new image URL, and to reconfigure GetStream
    await updateUserProfile();
  }

  Future<void> updateBiography(String biography) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update biography without user');
      throw Exception('Cannot update biography without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update biography without profile');
      return;
    }

    if (state.userProfile?.biography == biography) {
      logger.i('[Profile Service] - Biography up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateBiography');
    await callable.call(<String, dynamic>{
      'biography': biography,
    });

    logger.i('[Profile Service] - Biography updated');
    final Profile profile = state.userProfile?.copyWith(biography: biography) ?? Profile.empty().copyWith(biography: biography);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateAccentColor(String accentColor) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update accent color without user');
      throw Exception('Cannot update accent color without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update accent color without profile');
      return;
    }

    if (state.userProfile?.accentColor == accentColor) {
      logger.i('[Profile Service] - Accent color up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateAccentColor');
    await callable.call(<String, dynamic>{
      'accentColor': accentColor,
    });

    logger.i('[Profile Service] - Accent color updated');
    final Profile profile = state.userProfile?.copyWith(accentColor: accentColor) ?? Profile.empty().copyWith(accentColor: accentColor);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateFeatureFlags(Set<String> flags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update feature flags without user');
      throw Exception('Cannot update feature flags without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update feature flags without profile');
      return;
    }

    if (state.userProfile?.featureFlags == flags) {
      logger.i('[Profile Service] - Feature flags up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateFeatureFlags');
    await callable.call(<String, dynamic>{
      'featureFlags': flags.toList(),
    });

    logger.i('[Profile Service] - Feature flags updated');
    final Profile profile = state.userProfile?.copyWith(featureFlags: flags) ?? Profile.empty().copyWith(featureFlags: flags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> updateVisibilityFlags(Set<String> flags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.currentUser;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update visibility flags without user');
      throw Exception('Cannot update visibility flags without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update visibility flags without profile');
      return;
    }

    if (state.userProfile?.visibilityFlags == flags) {
      logger.i('[Profile Service] - Visibility flags up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateVisibilityFlags');
    await callable.call(<String, dynamic>{
      'visibilityFlags': flags.toList(),
    });

    logger.i('[Profile Service] - Visibility flags updated');
    final Profile profile = state.userProfile?.copyWith(visibilityFlags: flags) ?? Profile.empty().copyWith(visibilityFlags: flags);
    state = state.copyWith(userProfile: profile);
    userProfileStreamController.sink.add(profile);
  }

  Future<void> deleteProfile() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    logger.d('[Profile Service] - Deleting profile for user ${firebaseAuth.currentUser?.uid}');

    if (firebaseAuth.currentUser == null) {
      logger.e('[Profile Service] - Cannot delete profile without user');
      return;
    }

    await firebaseFunctions.httpsCallable('profile-deleteProfile').call();
    state = ProfileControllerState.initialState();

    logger.i('[Profile Service] - Profile deleted');
  }
}
