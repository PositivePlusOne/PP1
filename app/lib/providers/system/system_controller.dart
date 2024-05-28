// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/promotions_controller.dart';
import 'package:app/providers/profiles/company_sectors_controller.dart';
import 'package:app/providers/profiles/gender_controller.dart';
import 'package:app/providers/profiles/hiv_status_controller.dart';
import 'package:app/providers/profiles/interests_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import '../../services/third_party.dart';

part 'system_controller.freezed.dart';
part 'system_controller.g.dart';

enum SystemEnvironment { develop, staging, production }

@freezed
class SystemControllerState with _$SystemControllerState {
  const factory SystemControllerState({
    required SystemEnvironment environment,
    required bool showingSemanticsDebugger,
    required bool showingDebugMessages,
    @Default(false) hasPerformedInitialSetup,
    @Default([]) List<TargetFeed> disabledFeeds,
    @Default(false) secureScreen,
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
  }) = _SystemControllerState;

  factory SystemControllerState.create({
    required SystemEnvironment environment,
  }) =>
      SystemControllerState(
        environment: environment,
        showingSemanticsDebugger: false,
        showingDebugMessages: false,
      );
}

typedef FirebaseEndpoint = Tuple2<String, int>;

@Riverpod(keepAlive: true)
class SystemController extends _$SystemController {
  static const String kEnvironmentSystemKey = 'ENVIRONMENT';

  static const String kFirebaseAuthEndpointSystemKey = 'FB_AUTH_ENDPOINT';
  static const String kFirebaseFirestoreEndpointSystemKey = 'FB_FIRESTORE_ENDPOINT';
  static const String kFirebaseStorageEndpointSystemKey = 'FB_STORAGE_ENDPOINT';
  static const String kFirebaseFunctionsEndpointSystemKey = 'FB_FUNCTIONS_ENDPOINT';

  static const String kFirebaseRemoteConfigFeedPromotionFrequencyKey = 'feed_promotion_injection_frequency';
  static const String kFirebaseRemoteConfigChatPromotionFrequencyKey = 'chat_promotion_injection_frequency';
  static const String kFirebaseRemoteConfigFeedUpdateCheckFrequencyKey = 'feed_update_periodic_check_frequency';

  static const String kFirebaseRemoteConfigDisabledFeedsKey = 'disabled_feeds';
  static const String kFirebaseRemoteConfigFeedRefreshTimeoutKey = 'feed_refresh_timeout';

  static const String kFirebaseRemoteConfigAppsFlyerOneLinkKey = 'apps_flyer_one_link';

  static const String kFirebaseRemoteConfigAuthTimeoutKey = 'auth_timeout';
  static const int kDefaultAuthTimeout = 60009;

  Future<int> getBiometricAuthTimeout() async {
    final FirebaseRemoteConfig firebaseRemoteConfig = await ref.read(firebaseRemoteConfigProvider.future);
    final int firebseAuthTimeout = firebaseRemoteConfig.getInt(SystemController.kFirebaseRemoteConfigAuthTimeoutKey);
    if (firebseAuthTimeout <= 0) {
      return kDefaultAuthTimeout;
    }
    return firebseAuthTimeout;
  }

  Future<void> updateBiometricsLastVerifiedTime() async {
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);
    sharedPreferences.setInt(kBiometricsAcceptedLastTime, DateTime.now().millisecondsSinceEpoch);
  }

  void updateDisabledFeeds(List<TargetFeed> disabledFeeds) {
    state = state.copyWith(disabledFeeds: disabledFeeds);
  }

  void failedBiometric() async {
    final AppRouter router = providerContainer.read(appRouterProvider);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
    await userController.signOut();
    profileController.resetState();
    relationshipController.resetState();
    await router.replace(LoginRoute(senderRoute: HomeRoute));
  }

  Future<void> biometricsReverification([bool checkForTimeout = true]) async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);
    //? If the user has enabled biometric authentication, they will be prompted in this section otherwise skip
    await sharedPreferences.reload();
    final bool biometricPreferencesAgree = sharedPreferences.getBool(kBiometricsAcceptedKey) == true;
    if (!biometricPreferencesAgree || firebaseAuth.currentUser == null) {
      return;
    }

    if (checkForTimeout) {
      final int? lastCheckedEpoch = sharedPreferences.getInt(kBiometricsAcceptedLastTime);

      // Exit early if epoch time is not set
      if (lastCheckedEpoch == null) return;

      final int currentEpochTime = DateTime.now().millisecondsSinceEpoch;
      final int timeSinceLastAuthCheck = currentEpochTime - lastCheckedEpoch;

      // Exit early if within the timeout period
      if (timeSinceLastAuthCheck <= await systemController.getBiometricAuthTimeout()) return;
    }

    try {
      //? Authenticate via biometrics if the user is required to
      state = state.copyWith(secureScreen: true);
      final bool hasReauthenticated = await localAuthentication.authenticate(localizedReason: "Positive+1 needs to verify it's you");
      await sharedPreferences.setInt(kBiometricsAcceptedLastTime, DateTime.now().millisecondsSinceEpoch);
      if (!hasReauthenticated) {
        failedBiometric();
      }
    } on PlatformException catch (e) {
      if (e.code == 'user_cancel') {
        failedBiometric();
      }
    } finally {
      state = state.copyWith(secureScreen: false);
    }
  }

  SystemEnvironment get environment {
    const String environmentValue = String.fromEnvironment(kEnvironmentSystemKey, defaultValue: 'develop');
    switch (environmentValue) {
      case 'production':
        return SystemEnvironment.production;
      case 'staging':
        return SystemEnvironment.staging;
      default:
        return SystemEnvironment.develop;
    }
  }

  FirebaseEndpoint? get firebaseAuthEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseAuthEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseFunctionsEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseFunctionsEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseFirestoreEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseFirestoreEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseStorageEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseStorageEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  @override
  SystemControllerState build() {
    return SystemControllerState.create(environment: environment);
  }

  Future<void> preloadPackageInformation() async {
    final Logger logger = ref.read(loggerProvider);
    final PackageInfo packageInfo = await ref.read(packageInfoProvider.future);
    logger.i('preloadPackageInformation: $packageInfo');

    state = state.copyWith(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  Future<void> updateSystemConfiguration() async {
    final Logger logger = ref.read(loggerProvider);
    final InterestsController interestsController = ref.read(interestsControllerProvider.notifier);
    final GenderController genderController = ref.read(genderControllerProvider.notifier);
    final CompanySectorsController companySectorsController = ref.read(companySectorsControllerProvider.notifier);
    final HivStatusController hivStatusController = ref.read(hivStatusControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    final PromotionsController promotionsController = ref.read(promotionsControllerProvider.notifier);
    final FirebaseRemoteConfig firebaseRemoteConfig = await ref.read(firebaseRemoteConfigProvider.future);

    final String remoteDisabledFeedsStr = firebaseRemoteConfig.getString(kFirebaseRemoteConfigDisabledFeedsKey);
    final List<TargetFeed> remoteDisabledFeeds = [];
    if (remoteDisabledFeedsStr.isNotEmpty) {
      remoteDisabledFeeds.addAll(remoteDisabledFeedsStr.split(',').map((String origin) => TargetFeed.fromOrigin(origin.trim())).toList());
    }

    final String localDisabledFeedHash = state.disabledFeeds.map((TargetFeed feed) => TargetFeed.toOrigin(feed)).join(',');
    final String remoteDisabledFeedHash = remoteDisabledFeeds.map((TargetFeed feed) => TargetFeed.toOrigin(feed)).join(',');
    if (localDisabledFeedHash != remoteDisabledFeedHash) {
      logger.d('updateSystemConfiguration: Disabled feeds have changed');
      updateDisabledFeeds(remoteDisabledFeeds);
    }

    //* Data is assumed to be correct, if not the app cannot be used
    final EndpointResponse endpointResponse = await systemApiService.getSystemConfiguration();
    if (endpointResponse.data.isEmpty) {
      logger.e('updateSystemConfiguration: Failed to get system configuration');
      return;
    }

    final Map<String, Object?> payload = endpointResponse.data;
    logger.d('updateSystemConfiguration: $payload');

    final Map interests = payload.containsKey('interests') && payload['interests'] is Map<dynamic, dynamic> ? payload['interests'] as Map<dynamic, dynamic> : {};
    final List genders = payload.containsKey('genders') && payload['genders'] is List<dynamic> ? payload['genders'] as List<dynamic> : [];
    final List companySectors = payload.containsKey('companySectors') && payload['companySectors'] is List<dynamic> ? payload['companySectors'] as List<dynamic> : [];
    final List hivStatuses = payload.containsKey('medicalConditions') && payload['medicalConditions'] is List<dynamic> ? payload['medicalConditions'] as List<dynamic> : [];
    final List promotions = payload.containsKey('promotions') && payload['promotions'] is List<dynamic> ? payload['promotions'] as List<dynamic> : [];
    final Set<String> supportedProfiles = (payload.containsKey('supportedProfiles') && payload['supportedProfiles'] is List<dynamic> ? payload['supportedProfiles'] as List<dynamic> : []).whereType<String>().toSet();

    final List popularTags = payload.containsKey('popularTags') && payload['popularTags'] is List<dynamic> ? payload['popularTags'] as List<dynamic> : [];
    final List recentTags = payload.containsKey('recentTags') && payload['recentTags'] is List<dynamic> ? payload['recentTags'] as List<dynamic> : [];
    final List topicTags = payload.containsKey('topicTags') && payload['topicTags'] is List<dynamic> ? payload['topicTags'] as List<dynamic> : [];

    if (interests.isEmpty || genders.isEmpty || hivStatuses.isEmpty || companySectors.isEmpty) {
      throw Exception('Failed to load initial data from backend');
    }

    interestsController.onInterestsUpdated(interests);
    genderController.onGendersUpdated(genders);
    companySectorsController.onCompanySectorsUpdated(companySectors);
    hivStatusController.onHivStatusesUpdated(hivStatuses);

    tagsController.updatePopularTags(popularTags);
    tagsController.updateRecentTags(recentTags);
    tagsController.updateTopicTags(topicTags);

    profileController.onSupportedProfilesUpdated(supportedProfiles);

    try {
      final Iterable<Promotion> promotionDtos = promotions.map((dynamic promotion) => Promotion.fromJson(json.decodeSafe(promotion))).where((element) => element.flMeta?.id?.isNotEmpty == true).toList();
      await promotionsController.appendPromotions(promotions: promotionDtos);
    } catch (e) {
      logger.e('updateSystemConfiguration: Failed to parse promotions');
    }

    state = state.copyWith(hasPerformedInitialSetup: true);
    logger.i('updateSystemConfiguration: Completed');
  }

  //* Travels to a page given on development which allows the users to test the app
  Future<void> launchDevelopmentTooling() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('launchDevelopmentTooling');

    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const DevelopmentRoute());
  }

  //* Travels to a page given on development which allows the users to test the app
  Future<void> returnToHomePage() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    if (appRouter.current is! HomeRoute) {
      appRouter.replaceAll([const HomeRoute()]);
    }
  }

  Future<bool> isDeviceAppleSimulator() async {
    final Logger logger = ref.read(loggerProvider);
    final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);

    logger.d('isDeviceAppleSimulator: $deviceInfo');
    return deviceInfo is IosDeviceInfo && deviceInfo.isPhysicalDevice == false;
  }

  Future<void> handleFatalException(String errorMessage) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.e('handleFatalException: $errorMessage');
    await appRouter.replaceAll([ErrorRoute(errorMessage: errorMessage)]);
  }

  Future<void> openSettings() async {
    final Logger logger = ref.read(loggerProvider);
    final bool isAndroid = UniversalPlatform.isAndroid;
    final bool isIOS = UniversalPlatform.isIOS;

    if (isAndroid) {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
      return;
    }

    if (isIOS) {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
      return;
    }

    logger.e('Unsupported platform, cannot open settings');
  }

  Future<void> openPermissionSettings() async {
    final Logger logger = ref.read(loggerProvider);
    final bool isAndroid = UniversalPlatform.isAndroid;
    final bool isIOS = UniversalPlatform.isIOS;

    if (isAndroid) {
      await AppSettings.openAppSettings(type: AppSettingsType.security);
      return;
    }

    if (isIOS) {
      await AppSettings.openAppSettings(type: AppSettingsType.security);
      return;
    }

    logger.e('Unsupported platform, cannot open settings');
  }

  void toggleSemanticsDebugger() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('toggleSemanticsDebugger: ${!state.showingSemanticsDebugger}');

    state = state.copyWith(showingSemanticsDebugger: !state.showingSemanticsDebugger);
  }

  void toggleDebugMessages() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('toggleDebugMessages: ${!state.showingDebugMessages}');

    state = state.copyWith(showingDebugMessages: !state.showingDebugMessages);
  }

  Future<bool> isFirstInstall() async {
    final Logger logger = ref.read(loggerProvider);
    final FlutterSecureStorage flutterSecureStorage = await ref.read(flutterSecureStorageProvider.future);
    logger.d('isFirstInstall');

    return await flutterSecureStorage.read(key: kIsFirstInstallKey) == null;
  }

  Future<void> notifyFirstInstall() async {
    final Logger logger = ref.read(loggerProvider);
    final FlutterSecureStorage flutterSecureStorage = await ref.read(flutterSecureStorageProvider.future);
    logger.d('notifyFirstInstall');
    await flutterSecureStorage.write(key: kIsFirstInstallKey, value: 'false');
  }

  Future<void> resetSharedPreferences() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    logger.d('resetSharedPreferences');

    await sharedPreferences.clear();
  }

  Future<void> setAppBadgeCount(int count) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[SystemController] setAppBadgeCount: $count');

    final bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (!isSupported) {
      logger.d('[SystemController] setAppBadgeCount: App badges not supported');
      return;
    }

    await FlutterAppBadger.updateBadgeCount(count);
    logger.i('[SystemController] setAppBadgeCount: Completed');
  }

  Future<void> resetAppBadges() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[SystemController] resetAppBadges');

    logger.d('[SystemController] checking for notification permissions');
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final bool hasNotificationPermissions = await notificationsController.hasPushNotificationPermissions();

    if (!hasNotificationPermissions) {
      logger.d('[SystemController] resetAppBadges: No notification permissions');
      return;
    }

    final bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (!isSupported) {
      logger.d('[SystemController] resetAppBadges: App badges not supported');
      return;
    }

    await FlutterAppBadger.removeBadge();
    logger.i('[SystemController] resetAppBadges: Completed');
  }
}
