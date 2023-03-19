// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:tuple/tuple.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import '../../constants/key_constants.dart';
import '../../services/third_party.dart';

part 'system_controller.freezed.dart';
part 'system_controller.g.dart';

enum SystemEnvironment { develop, staging, production }

@freezed
class SystemControllerState with _$SystemControllerState {
  const factory SystemControllerState({
    required SystemEnvironment environment,
    required bool localNotificationsInitialized,
    required bool remoteNotificationsInitialized,
    required bool showingSemanticsDebugger,
  }) = _SystemControllerState;

  factory SystemControllerState.create({
    required SystemEnvironment environment,
  }) =>
      SystemControllerState(
        environment: environment,
        localNotificationsInitialized: false,
        remoteNotificationsInitialized: false,
        showingSemanticsDebugger: false,
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

  StreamSubscription<RemoteMessage>? firebaseMessagingStreamSubscription;

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

  Future<void> handleFatalException(String errorMessage) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.e('handleFatalException: $errorMessage');
    appRouter.removeWhere((route) => true);
    await appRouter.push(ErrorRoute(errorMessage: errorMessage));
  }

  Future<bool> requestPushNotificationPermissions() async {
    final Logger logger = ref.read(loggerProvider);
    final bool pushNotificationPermissions = await hasPushNotificationPermissions();
    final bool requestPushNotificationPermissions = await canRequestPushNotificationPermissions();

    if (pushNotificationPermissions || !requestPushNotificationPermissions) {
      logger.d('requestPushNotificationPermissions: No push notification permissions or cannot request permissions');
      return false;
    }

    final PermissionStatus permissionStatus = await Permission.notification.request();
    logger.d('requestPushNotificationPermissions: $permissionStatus');

    return permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.limited;
  }

  Future<bool> hasPushNotificationPermissions() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final PermissionStatus permissionStatus = await Permission.notification.status;

    final bool hasOptedIn = sharedPreferences.getBool(kNotificationsAcceptedKey) ?? false;

    logger.d('hasPushNotificationPermissions: $hasOptedIn, $permissionStatus');
    return (permissionStatus.isGranted || permissionStatus.isLimited) && hasOptedIn;
  }

  Future<bool> canRequestPushNotificationPermissions() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final PermissionStatus permissionStatus = await Permission.notification.status;

    final bool hasOptedIn = sharedPreferences.getBool(kNotificationsAcceptedKey) ?? false;
    final bool isStateWhereCanRequestPermissions = permissionStatus == PermissionStatus.denied;
    final bool isIosSimulator = await isDeviceAppleSimulator();
    logger.d('canRequestPushNotificationPermissions: $hasOptedIn, $isStateWhereCanRequestPermissions, $isIosSimulator');

    return hasOptedIn && isStateWhereCanRequestPermissions && !isIosSimulator;
  }

  Future<void> setupPushNotificationListeners() async {
    final Logger logger = ref.read(loggerProvider);

    final bool hasPushNotificationPermissions = await this.hasPushNotificationPermissions();
    final bool isDeviceIosSimulator = await isDeviceAppleSimulator();

    if (!hasPushNotificationPermissions || isDeviceIosSimulator) {
      logger.d('setupPushNotificationListeners: No push notification permissions or device is an iOS simulator');
      return;
    }

    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = ref.read(flutterLocalNotificationsPluginProvider);

    final bool isDeviceIos = await ref.read(deviceInfoProvider.future).then((deviceInfo) => deviceInfo is IosDeviceInfo);
    final AndroidFlutterLocalNotificationsPlugin? pluginSettings = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (!state.localNotificationsInitialized) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: onLocalNotificationReceived);
      const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, macOS: initializationSettingsDarwin, linux: initializationSettingsLinux);
      final bool? initializedSuccessfully = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );

      state = state.copyWith(localNotificationsInitialized: initializedSuccessfully ?? false);
      logger.d('setupPushNotificationListeners: Initialized local notifications: $initializedSuccessfully');
    }

    if (isDeviceIos) {
      await firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      logger.d('setupPushNotificationListeners: Set foreground notification presentation options for iOS');
    }

    if (pluginSettings != null) {
      // TODO(ryan): Setup high importance channels for Android foreground notifications
      // await pluginSettings.createNotificationChannel();
    }

    //! This is on a concrete implementation which sucks for testing!
    await firebaseMessagingStreamSubscription?.cancel();
    firebaseMessagingStreamSubscription = FirebaseMessaging.onMessage.listen(onRemoteNotificationReceived);

    logger.d('setupPushNotificationListeners: Subscribed to remote notifications');
    state = state.copyWith(remoteNotificationsInitialized: true);
  }

  void onRemoteNotificationReceived(RemoteMessage event) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onRemoteNotificationReceived: $event');
  }

  void onLocalNotificationReceived(int id, String? title, String? body, String? payload) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onLocalNotificationReceived: $id, $title, $body, $payload');
  }

  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('onDidReceiveBackgroundNotificationResponse: $details');
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onDidReceiveNotificationResponse: $details');
  }

  void toggleSemanticsDebugger() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('toggleSemanticsDebugger: ${!state.showingSemanticsDebugger}');

    state = state.copyWith(showingSemanticsDebugger: !state.showingSemanticsDebugger);
  }
}
