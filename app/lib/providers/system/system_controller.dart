// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:app/constants/key_constants.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/gender_controller.dart';
import 'package:app/providers/content/hiv_status_controller.dart';
import 'package:app/providers/content/interests_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
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

  Future<void> preloadBuildInformation() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final InterestsController interestsController = ref.read(interestsControllerProvider.notifier);
    final GenderController genderController = ref.read(genderControllerProvider.notifier);
    final HivStatusController hivStatusController = ref.read(hivStatusControllerProvider.notifier);
    // final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    // final User? user = await firebaseAuth.authStateChanges().first;
    // if (user == null) {
    //   logger.i('preloadBuildInformation: No user found, signing in anonymously');
    //   await firebaseAuth.signInAnonymously();
    // }

    logger.i('preloadBuildInformation');
    final HttpsCallable callable = firebaseFunctions.httpsCallable('system-getBuildInformation');
    final HttpsCallableResult<dynamic> result = await callable.call({
      'locale': 'en',
    });

    logger.i('preloadBuildInformation: $result');

    //* Data is assumed to be correct, if not the app cannot be used
    final Map<String, dynamic> data = json.decodeSafe(result.data);
    interestsController.onInterestsUpdated(data['interests'] as Map<String, dynamic>);
    genderController.onGendersUpdated(data['genders'] as List<dynamic>);
    hivStatusController.onHivStatusesUpdated(data['medicalConditions'] as List<dynamic>);

    if (data.containsKey('profile') && data['profile'].keys.isNotEmpty) {
      logger.i('preloadBuildInformation: Found profile data');
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final Map<String, dynamic> profileData = data['profile'] as Map<String, dynamic>;
      final Profile profile = Profile.fromJson(profileData);
      profileController.state = profileController.state.copyWith(userProfile: profile);
      profileController.userProfileStreamController.sink.add(profile);
    }
  }

  //* Travels to a page given on development which allows the users to test the app
  Future<void> launchDevelopmentTooling() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('launchDevelopmentTooling');

    if (state.environment != SystemEnvironment.develop) {
      logger.d('launchDevelopmentTooling: Not in development environment');
      return;
    }

    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const DevelopmentRoute());
  }

  Future<bool> isDeviceAppleSimulator() async {
    final Logger logger = ref.read(loggerProvider);
    final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);

    logger.d('isDeviceAppleSimulator: $deviceInfo');
    return deviceInfo is IosDeviceInfo && deviceInfo.isPhysicalDevice == false;
  }

  //* Checks if the device is an android

  Future<void> handleFatalException(String errorMessage) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.e('handleFatalException: $errorMessage');
    appRouter.removeWhere((route) => true);
    await appRouter.push(ErrorRoute(errorMessage: errorMessage));
  }

  Future<void> openSettings() async {
    final Logger logger = ref.read(loggerProvider);
    final bool isAndroid = UniversalPlatform.isAndroid;
    final bool isIOS = UniversalPlatform.isIOS;

    if (isAndroid) {
      const OpenSettingsPlusAndroid openSettingsPlusAndroid = OpenSettingsPlusAndroid();
      await openSettingsPlusAndroid.notification();
      return;
    }

    if (isIOS) {
      const OpenSettingsPlusIOS openSettingsPlusIOS = OpenSettingsPlusIOS();
      await openSettingsPlusIOS.settings();
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
    final FlutterSecureStorage flutterSecureStorage = await ref.read(flutterSecureStorageProvider.future);
    return await flutterSecureStorage.read(key: kIsFirstInstallKey) == null;
  }

  Future<void> notifyFirstInstall() async {
    final FlutterSecureStorage flutterSecureStorage = await ref.read(flutterSecureStorageProvider.future);
    await flutterSecureStorage.write(key: kIsFirstInstallKey, value: 'false');
  }

  Future<void> resetSharedPreferences() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    logger.d('resetSharedPreferences');

    await sharedPreferences.clear();
  }
}
