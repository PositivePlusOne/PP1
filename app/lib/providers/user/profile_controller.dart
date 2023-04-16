// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/geo/user_location.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

part 'profile_controller.freezed.dart';
part 'profile_controller.g.dart';

@freezed
class ProfileControllerState with _$ProfileControllerState {
  const factory ProfileControllerState({
    UserProfile? userProfile,
  }) = _ProfileControllerState;

  factory ProfileControllerState.initialState() => const ProfileControllerState();
}

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  final StreamController<UserProfile> userProfileStreamController = StreamController<UserProfile>.broadcast();
  StreamSubscription<UserProfile>? userProfileStreamSubscription;

  final Map<String, UserProfile> userProfileCache = {};

  bool get isSettingUpUserProfile {
    if (state.userProfile == null) {
      return false;
    }

    final bool hasSetupProfileColor = state.userProfile!.accentColor.isNotEmpty;
    return !hasSetupProfileColor;
  }

  @override
  ProfileControllerState build() {
    return ProfileControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Setting up listeners');

    await userProfileStreamSubscription?.cancel();
    userProfileStreamSubscription = userProfileStreamController.stream.listen(onUserProfileUpdated);
  }

  Future<void> reset() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Resetting');
    state = ProfileControllerState.initialState();
  }

  void onUserProfileUpdated(UserProfile event) {
    final Logger logger = ref.read(loggerProvider);

    logger.i('[Profile Service] - User profile updated: $event - Syncing data if needed');
    failSilently(ref, () => updatePhoneNumber());
    failSilently(ref, () => updateEmailAddress());
  }

  Future<void> updateUserProfile() async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);
    final User? user = firebaseAuth.currentUser;

    if (user == null) {
      logger.i('[Profile Service] - No current user');
      return;
    }

    logger.i('[Profile Service] - Loading current user profile: $user');

    final UserProfile userProfile = await getProfile(user.uid, skipCacheLookup: true);
    userProfileStreamController.sink.add(userProfile);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> viewProfile(UserProfile profile) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    final String id = profile.flMeta?.id ?? '';
    if (id.isEmpty) {
      throw Exception('User profile has no ID');
    }

    logger.i('Navigating to profile: ${profile.id}');
    await appRouter.push(ProfileRoute(userId: id));
  }

  Future<UserProfile> getProfile(String uid, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    logger.i('[Profile Service] - Loading profile: $uid');
    if (userProfileCache.containsKey(uid) && !skipCacheLookup) {
      final UserProfile userProfile = userProfileCache[uid]!;
      logger.i('[Profile Service] - Profile found from repository: $userProfile');
      return userProfile;
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
    final UserProfile userProfile = UserProfile.fromJson(data);
    userProfileCache[uid] = userProfile;

    return userProfile;
  }

  Future<void> updateFirebaseMessagingToken() async {
    final NotificationsControllerState notificationControllerState = ref.read(notificationsControllerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = userController.state.user;

    if (state.userProfile == null) {
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

    if (state.userProfile?.fcmToken == firebaseMessagingToken) {
      logger.i('[Profile Service] - Firebase messaging token up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateFcmToken');
    final HttpsCallableResult response = await callable.call(<String, dynamic>{
      'fcmToken': firebaseMessagingToken,
    });

    logger.i('[Profile Service] - Firebase messaging token updated: $response');
    await analyticsController.trackEvent(AnalyticEvents.notificationFcmTokenUpdated, properties: {
      'fcmToken': firebaseMessagingToken,
    });
  }

  Future<void> createInitialProfile() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final BuildContext? context = ref.read(appRouterProvider).navigatorKey.currentContext;

    if (context == null) {
      logger.e('[Profile Service] - Cannot create profile without context');
      throw Exception('Cannot create profile without context');
    }

    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot create profile without user');
      throw Exception('Cannot create profile without user');
    }

    if (state.userProfile != null) {
      logger.w('[Profile Service] - Cannot create profile when profile already exists');
      return;
    }

    final Locale locale = Localizations.localeOf(context);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-createProfile');
    final HttpsCallableResult response = await callable.call({
      'locale': locale.countryCode,
    });

    logger.i('[Profile Service] - Profile created: $response');
    final Map<String, Object?> data = json.decodeSafe(response.data);
    if (data.isEmpty) {
      return;
    }

    final UserProfile userProfile = UserProfile.fromJson(data);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateEmailAddress({String? emailAddress}) async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = ref.read(userControllerProvider).user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update email address without user');
      throw Exception('Cannot update email address without user');
    }

    if (profileController.state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update email address without profile');
      return;
    }

    final String newEmailAddress = emailAddress ?? user.email ?? '';
    if (newEmailAddress.isEmpty) {
      logger.e('[Profile Service] - Cannot update email address without email address');
      throw Exception('Cannot update email address without email address');
    }

    if (profileController.state.userProfile?.email == newEmailAddress) {
      logger.i('[Profile Service] - Email address up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateEmailAddress');
    await callable.call(<String, dynamic>{
      'email': newEmailAddress,
    });

    logger.i('[Profile Service] - Email address updated');
    final UserProfile userProfile = state.userProfile?.copyWith(email: newEmailAddress) ?? UserProfile.empty().copyWith(email: newEmailAddress);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updatePhoneNumber({String? phoneNumber}) async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = ref.read(userControllerProvider).user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update phone number without user');
      throw Exception('Cannot update phone number without user');
    }

    if (profileController.state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update phone number without profile');
      return;
    }

    final String actualPhoneNumber = phoneNumber ?? user.phoneNumber ?? '';
    if (actualPhoneNumber.isEmpty) {
      logger.e('[Profile Service] - Cannot update phone number without phone number');
      throw Exception('Cannot update phone number without phone number');
    }

    if (profileController.state.userProfile?.phoneNumber == actualPhoneNumber) {
      logger.i('[Profile Service] - Phone number up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updatePhoneNumber');
    await callable.call(<String, dynamic>{
      'phoneNumber': actualPhoneNumber,
    });

    logger.i('[Profile Service] - Phone number updated');
    final UserProfile userProfile = state.userProfile?.copyWith(phoneNumber: actualPhoneNumber) ?? UserProfile.empty().copyWith(phoneNumber: actualPhoneNumber);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateName(String name, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update name without user');
      throw Exception('Cannot update name without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update name without profile');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateName');
    await callable.call(<String, dynamic>{
      'name': name,
      'visibilityFlags': visibilityFlags.toList(),
    });

    logger.i('[Profile Service] - Name updated');
    final UserProfile userProfile = state.userProfile?.copyWith(name: name) ?? UserProfile.empty().copyWith(name: name);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateDisplayName(String displayName) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update display name without user');
      throw Exception('Cannot update display name without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update display name without profile');
      return;
    }

    if (state.userProfile?.displayName == displayName) {
      logger.i('[Profile Service] - Display name up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateDisplayName');
    await callable.call(<String, dynamic>{
      'displayName': displayName,
    });

    logger.i('[Profile Service] - Display name updated');
    final UserProfile userProfile = state.userProfile?.copyWith(displayName: displayName) ?? UserProfile.empty().copyWith(displayName: displayName);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateBirthday(String birthday, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
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
    final UserProfile userProfile = state.userProfile?.copyWith(birthday: birthday, visibilityFlags: visibilityFlags) ?? UserProfile.empty().copyWith(birthday: birthday, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateInterests(Set<String> interests, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
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
    final UserProfile userProfile = state.userProfile?.copyWith(interests: interests, visibilityFlags: visibilityFlags) ?? UserProfile.empty().copyWith(interests: interests, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateHivStatus(String status, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
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
    final UserProfile userProfile = state.userProfile?.copyWith(hivStatus: status, visibilityFlags: visibilityFlags) ?? UserProfile.empty().copyWith(hivStatus: status, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateGenders(Set<String> genders, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
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
    final UserProfile userProfile = state.userProfile?.copyWith(genders: genders, visibilityFlags: visibilityFlags) ?? UserProfile.empty().copyWith(genders: genders, visibilityFlags: visibilityFlags);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateLocation(Location? location, Set<String> visibilityFlags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot update location without user');
      throw Exception('Cannot update location without user');
    }

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update location without profile');
      return;
    }

    // if (state.userProfile?. == location && state.userProfile?.visibilityFlags == visibilityFlags) {
    //   logger.i('[Profile Service] - location up to date');
    //   return;
    // }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateLocation');
    if (location != null) {
      await callable.call(<String, dynamic>{
        'location': {
          'latitude': location.lat,
          'longitude': location.lng,
        },
        'visibilityFlags': visibilityFlags.toList(),
      });
    } else {
      // Users can skip the location. If no location is passed then the "locationSkipped" flag will be set to true.
      await callable.call(<String, dynamic>{
        'visibilityFlags': visibilityFlags.toList(),
      });
    }

    logger.i('[Profile Service] - Genders updated');
    final UserProfile userProfile = state.userProfile?.copyWith(
          location: location == null ? null : UserLocation(latitude: location.lat, longitude: location.lng),
          locationSkipped: location == null,
          visibilityFlags: visibilityFlags,
        ) ??
        UserProfile.empty().copyWith(
          location: location == null ? null : UserLocation(latitude: location.lat, longitude: location.lng),
          locationSkipped: location == null,
          visibilityFlags: visibilityFlags,
        );
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateFeatureFlags(Set<String> flags) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final User? user = userController.state.user;
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
      'flags': flags.toList(),
    });

    logger.i('[Profile Service] - Feature flags updated');
    final UserProfile userProfile = state.userProfile?.copyWith(featureFlags: flags) ?? UserProfile.empty().copyWith(featureFlags: flags);
    state = state.copyWith(userProfile: userProfile);
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
