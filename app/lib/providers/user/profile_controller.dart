// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/repositories.dart';
import '../../services/third_party.dart';

part 'profile_controller.freezed.dart';
part 'profile_controller.g.dart';

@freezed
class ProfileControllerState with _$ProfileControllerState {
  const factory ProfileControllerState({
    UserProfile? userProfile,
    @Default([]) List<UserProfile> followers,
    @Default([]) List<UserProfile> connections,
  }) = _ProfileControllerState;

  factory ProfileControllerState.initialState() => const ProfileControllerState();
}

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  ProfileControllerState build() {
    return ProfileControllerState.initialState();
  }

  Future<void> reset() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Resetting');
    state = ProfileControllerState.initialState();
  }

  Future<void> loadCurrentUserProfile() async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);
    final User? user = firebaseAuth.currentUser;

    logger.i('[Profile Service] - Loading current user profile: $user');

    final UserProfile userProfile = await getProfileById(user!.uid);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<UserProfile> getProfileById(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Box<UserProfile> userRepository = await ref.read(userProfileRepositoryProvider.future);

    logger.i('[Profile Service] - Loading profile: $uid');
    if (userRepository.containsKey(uid)) {
      final UserProfile userProfile = userRepository.get(uid)!;
      logger.i('[Profile Service] - Profile found from repository: $userProfile');
      return userProfile;
    }

    logger.i('[Profile Service] - Profile not found from repository, loading from firebase: $uid');
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-getProfile');
    final HttpsCallableResult response = await callable.call({
      'uid': uid,
    });

    logger.i('[Profile Service] - Profile loaded: $response');
    final Map<String, Object?> data = json.decodeSafe(response.data);
    if (data.isEmpty) {
      throw Exception('Profile not found');
    }

    return UserProfile.fromJson(data);
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

  Future<void> updateName(String name, List<String> visibilityFlags) async {
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
      'visibilityFlags': visibilityFlags,
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

  Future<void> updateBirthday(String birthday, List<String> visibilityFlags) async {
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

    if (state.userProfile?.birthday == birthday) {
      logger.i('[Profile Service] - Birthday up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateBirthday');
    await callable.call(<String, dynamic>{
      'birthday': birthday,
      'visibilityFlags': visibilityFlags,
    });

    logger.i('[Profile Service] - Birthday updated');
    final UserProfile userProfile = state.userProfile?.copyWith(birthday: birthday) ?? UserProfile.empty().copyWith(birthday: birthday);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateInterests(List<String> interests, List<String> visibilityFlags) async {
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

    if (state.userProfile?.interests == interests) {
      logger.i('[Profile Service] - Interests up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateInterests');
    await callable.call(<String, dynamic>{
      'interests': interests,
      'visibilityFlags': visibilityFlags,
    });

    logger.i('[Profile Service] - Interests updated');
    final UserProfile userProfile = state.userProfile?.copyWith(interests: interests) ?? UserProfile.empty().copyWith(interests: interests);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateHivStatus(String status, List<String> visibilityFlags) async {
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

    if (state.userProfile?.hivStatus == status) {
      logger.i('[Profile Service] - Hiv status up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateHivStatus');
    await callable.call(<String, dynamic>{
      'status': status,
      'visibilityFlags': visibilityFlags,
    });

    logger.i('[Profile Service] - Status updated');
    final UserProfile userProfile = state.userProfile?.copyWith(hivStatus: status) ?? UserProfile.empty().copyWith(hivStatus: status);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateGenders(List<String> genders, List<String> visibilityFlags) async {
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

    if (state.userProfile?.genders == genders) {
      logger.i('[Profile Service] - Genders up to date');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-updateGenders');
    await callable.call(<String, dynamic>{
      'genders': genders,
      'visibilityFlags': visibilityFlags,
    });

    logger.i('[Profile Service] - Genders updated');
    final UserProfile userProfile = state.userProfile?.copyWith(genders: genders) ?? UserProfile.empty().copyWith(genders: genders);
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
