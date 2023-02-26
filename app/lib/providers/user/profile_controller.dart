// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/user_profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/system_controller.dart';
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
  @override
  ProfileControllerState build() {
    return ProfileControllerState.initialState();
  }

  Future<void> reset() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Resetting');
    state = ProfileControllerState.initialState();
  }

  Future<void> loadProfile() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot load profile without user');
      throw Exception('Cannot load profile without user');
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-getProfile');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Profile loaded: $response');
    final Map<String, Object?> data = json.decodeSafe(response.data);
    if (data.isEmpty) {
      return;
    }

    final UserProfile userProfile = UserProfile.fromJson(data);
    state = state.copyWith(userProfile: userProfile);
  }

  Future<void> updateFirebaseMessagingToken() async {
    final SystemControllerState systemControllerState = ref.read(systemControllerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = userController.state.user;

    if (state.userProfile == null) {
      logger.w('[Profile Service] - Cannot update firebase messaging token without profile');
      return;
    }

    if (!systemControllerState.remoteNotificationsInitialized) {
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

    final User? user = userController.state.user;
    if (user == null) {
      logger.e('[Profile Service] - Cannot create profile without user');
      throw Exception('Cannot create profile without user');
    }

    if (state.userProfile != null) {
      logger.w('[Profile Service] - Cannot create profile when profile already exists');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('profile-createProfile');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Profile created: $response');
    final Map<String, Object?> data = json.decodeSafe(response.data);
    if (data.isEmpty) {
      return;
    }

    final UserProfile userProfile = UserProfile.fromJson(data);
    state = state.copyWith(userProfile: userProfile);
  }
}
