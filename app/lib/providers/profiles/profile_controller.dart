// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../services/third_party.dart';

part 'profile_controller.freezed.dart';
part 'profile_controller.g.dart';

@freezed
class ProfileControllerState with _$ProfileControllerState {
  const factory ProfileControllerState({
    Profile? currentProfile,
    @Default({}) Set<String> availableProfileIds,
  }) = _ProfileControllerState;

  factory ProfileControllerState.initialState() => const ProfileControllerState(
        availableProfileIds: {},
      );
}

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  StreamSubscription<User?>? userStreamSubscription;
  StreamSubscription<CacheKeyUpdatedEvent>? cacheKeyUpdatedEventSubscription;

  String? get currentProfileId => state.currentProfile?.flMeta?.id;

  bool get isCurrentlyAuthenticatedUser {
    if (currentProfileId?.isEmpty ?? true) {
      return false;
    }

    return currentProfileId == ref.read(firebaseAuthProvider).currentUser?.uid;
  }

  bool get isCurrentlyOrganisation {
    return state.currentProfile?.featureFlags.contains(kFeatureFlagOrganisationControls) ?? false;
  }

  bool get hasSetupProfile {
    if (state.currentProfile == null) {
      return false;
    }

    if (!isCurrentlyAuthenticatedUser) {
      return true;
    }

    // TODO(ryan): This check should probably be better than are we missing this string
    return state.currentProfile?.accentColor.isNotEmpty ?? false;
  }

  @override
  ProfileControllerState build() {
    return ProfileControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.i('[Profile Service] - Setting up listeners');
    await userStreamSubscription?.cancel();
    userStreamSubscription = firebaseAuth.authStateChanges().listen(onAuthenticatedUserChanged);

    await cacheKeyUpdatedEventSubscription?.cancel();
    cacheKeyUpdatedEventSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  Future<void> onAuthenticatedUserChanged(User? user) async {
    final Logger logger = ref.read(loggerProvider);

    // The users profiles are preloaded by the call to system, so we only need to wipe the state if the user is null
    if (user == null) {
      logger.i('[Profile Service] - Authenticated user changed to null, resetting state');
      resetState();
      return;
    }

    logger.i('[Profile Service] - Authenticated user changed to ${user.uid}');
    if (state.availableProfileIds.isEmpty) {
      onSupportedProfilesUpdated({user.uid});
    }
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Profile Service] - Resetting');

    state = ProfileControllerState.initialState();
    providerContainer.read(eventBusProvider).fire(const ProfileSwitchedEvent(''));
  }

  void onSupportedProfilesUpdated(Set<String> availableProfileIds) {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final String currentUserUid = firebaseAuth.currentUser?.uid ?? '';
    final Profile? currentUserProfile = cacheController.getFromCache(currentUserUid);

    if (currentUserUid.isEmpty || currentUserProfile == null) {
      logger.i('[Profile Service] - Current user uid: $currentUserUid');
      availableProfileIds.add(currentUserUid);
    }

    logger.i('[Profile Service] - Supported profiles updated: $availableProfileIds');
    state = state.copyWith(availableProfileIds: availableProfileIds, currentProfile: currentUserProfile);
    providerContainer.read(eventBusProvider).fire(ProfileSwitchedEvent(currentUserUid));
  }

  Future<void> switchProfile({String uid = ''}) async {
    final Logger logger = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.i('[Profile Service] - Switching user: $uid');
    if (uid.isNotEmpty && !state.availableProfileIds.contains(uid)) {
      throw Exception('Cannot switch to user that is not available - $uid');
    }

    final Profile profile = await getProfile(uid);

    state = state.copyWith(currentProfile: profile);
    eventBus.fire(ProfileSwitchedEvent(uid));
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    final Logger logger = ref.read(loggerProvider);
    if (!event.isCurrentProfileChangeEvent) {
      return;
    }

    logger.i('[Profile Service] - Cache key updated, reloading current profile');
    final Profile? currentProfile = ref.read(cacheControllerProvider.notifier).getFromCache(event.key);
    if (currentProfile == null) {
      logger.e('[Profile Service] - Current profile is null, cannot reload');
      return;
    }

    state = state.copyWith(currentProfile: currentProfile);
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
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    logger.i('[Profile Service] - Loading profile: $uid');
    if (!skipCacheLookup) {
      final Profile? cachedProfile = cacheController.getFromCache(uid);
      if (cachedProfile != null) {
        logger.i('[Profile Service] - Profile loaded from cache: $uid');
        return cachedProfile;
      }
    }

    logger.i('[Profile Service] - Profile not found from repository or skipped, loading from firebase: $uid');
    final Map<String, Object?> data = await profileApiService.getProfile(uid: uid);
    logger.i('[Profile Service] - Profile parsed: $data');

    final Profile profile = Profile.fromJson(data);
    return profile;
  }

  Future<void> updateFirebaseMessagingToken() async {
    final NotificationsControllerState notificationControllerState = ref.read(notificationsControllerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final User? user = userController.currentUser;
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (state.currentProfile == null) {
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

    if (state.currentProfile?.fcmToken == firebaseMessagingToken) {
      logger.i('[Profile Service] - Firebase messaging token up to date');
      return;
    }

    await profileApiService.updateFcmToken(fcmToken: firebaseMessagingToken);
    analyticsController.trackEvent(AnalyticEvents.notificationFcmTokenUpdated, properties: {
      'fcmToken': firebaseMessagingToken,
    });
  }

  Future<void> updateEmailAddress({String? emailAddress}) async {
    final Logger logger = ref.read(loggerProvider);
    final User? user = ref.read(firebaseAuthProvider).currentUser;
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (user == null || state.currentProfile == null) {
      logger.e('[Profile Service] - Cannot update email address without user or profile');
      return;
    }

    final String newEmailAddress = emailAddress ?? user.email ?? '';
    if (newEmailAddress.isEmpty) {
      logger.e('[Profile Service] - Cannot update email address without email address');
      return;
    }

    if (state.currentProfile?.email == newEmailAddress) {
      logger.i('[Profile Service] - Email address up to date');
      return;
    }

    await profileApiService.updateEmailAddress(emailAddress: newEmailAddress);
    logger.i('[Profile Service] - Email address updated');
  }

  Future<void> updatePhoneNumber({String? phoneNumber}) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update phone number without profile');
      return;
    }

    final String actualPhoneNumber = phoneNumber ?? state.currentProfile?.phoneNumber ?? '';
    if (actualPhoneNumber.isEmpty) {
      logger.e('[Profile Service] - Cannot update phone number without phone number');
      throw Exception('Cannot update phone number without phone number');
    }

    if (state.currentProfile?.phoneNumber == actualPhoneNumber) {
      logger.i('[Profile Service] - Phone number up to date');
      return;
    }

    await profileApiService.updatePhoneNumber(phoneNumber: actualPhoneNumber);
    logger.i('[Profile Service] - Phone number updated');
  }

  Future<void> updateName(String name, Set<String> visibilityFlags) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (state.currentProfile == null) {
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

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update display name without profile');
      return;
    }

    if (state.currentProfile?.displayName == displayName) {
      logger.i('[Profile Service] - Display name up to date');
      return;
    }

    await profileApiService.updateDisplayName(displayName: displayName);
  }

  Future<void> updateBirthday(String birthday, Set<String> visibilityFlags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update birthday without profile');
      return;
    }

    if (state.currentProfile?.birthday == birthday && state.currentProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Birthday up to date');
      return;
    }

    await profileApiService.updateBirthday(
      birthday: birthday,
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updateInterests(Set<String> interests, Set<String> visibilityFlags) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update interests without profile');
      return;
    }

    if (state.currentProfile?.interests == interests && state.currentProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Interests up to date');
      return;
    }

    await profileApiService.updateInterests(
      interests: interests.toList(),
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updateHivStatus(String status, Set<String> visibilityFlags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update hiv status without profile');
      return;
    }

    if (state.currentProfile?.hivStatus == status && state.currentProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Hiv status up to date');
      return;
    }

    await profileApiService.updateHivStatus(
      hivStatus: status,
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updateGenders(Set<String> genders, Set<String> visibilityFlags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update genders without profile');
      return;
    }

    if (state.currentProfile?.genders == genders && state.currentProfile?.visibilityFlags == visibilityFlags) {
      logger.i('[Profile Service] - Genders up to date');
      return;
    }

    await profileApiService.updateGenders(
      genders: genders.toList(),
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updatePlace(PositivePlace? place, Set<String> visibilityFlags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update place without profile');
      return;
    }

    await profileApiService.updatePlace(
      description: place?.description ?? '',
      placeId: place?.placeId ?? '',
      latitude: place?.latitude ?? 0,
      longitude: place?.longitude ?? 0,
      visibilityFlags: visibilityFlags,
    );
  }

  Future<void> updateReferenceImage(String imagePath) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);

    final File picture = File(imagePath);
    final String base64String = await Isolate.run(() async {
      final Uint8List imageAsUint8List = await picture.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        return "";
      }

      final img.Image resizedImage = img.copyResize(decodedImage, width: 512);
      final List<int> encodedJpg = img.encodeJpg(resizedImage);

      return base64Encode(encodedJpg);
    });

    if (base64String.isEmpty) {
      logger.w('[Profile Service] - Cannot update reference image without image');
      return;
    }

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update reference image without profile');
      return;
    }

    await profileApiService.updateReferenceImage(base64String: base64String);
  }

  Future<void> updateProfileImage(String imagePath) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final File picture = File(imagePath);

    final String base64String = await Isolate.run(() async {
      final Uint8List imageAsUint8List = await picture.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        return "";
      }

      final img.Image resizedImage = img.copyResize(decodedImage, width: 512);
      final List<int> encodedJpg = img.encodeJpg(resizedImage);
      return base64Encode(encodedJpg);
    });

    if (base64String.isEmpty) {
      logger.w('[Profile Service] - Cannot update profile image without image');
      return;
    }

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update profile image without profile');
      return;
    }

    await profileApiService.updateProfileImage(base64String: base64String);
  }

  Future<void> updateBiography(String biography) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update biography without profile');
      return;
    }

    if (state.currentProfile?.biography == biography) {
      logger.i('[Profile Service] - Biography up to date');
      return;
    }

    await profileApiService.updateBiography(biography: biography);
  }

  Future<void> updateAccentColor(String accentColor) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update accent color without profile');
      return;
    }

    if (state.currentProfile?.accentColor == accentColor) {
      logger.i('[Profile Service] - Accent color up to date');
      return;
    }

    await profileApiService.updateAccentColor(accentColor: accentColor);
  }

  Future<void> updateFeatureFlags(Set<String> flags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update feature flags without profile');
      return;
    }

    if (state.currentProfile?.featureFlags == flags) {
      logger.i('[Profile Service] - Feature flags up to date');
      return;
    }

    await profileApiService.updateFeatureFlags(featureFlags: flags);
  }

  Future<void> updateVisibilityFlags(Set<String> flags) async {
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentProfile == null) {
      logger.w('[Profile Service] - Cannot update visibility flags without profile');
      return;
    }

    if (state.currentProfile?.visibilityFlags == flags) {
      logger.i('[Profile Service] - Visibility flags up to date');
      return;
    }

    await profileApiService.updateVisibilityFlags(visibilityFlags: flags);
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
