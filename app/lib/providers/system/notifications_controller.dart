// Dart imports:
import 'dart:async';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/providers/system/system_controller.dart';
import '../../constants/key_constants.dart';
import '../../main.dart';
import '../../services/third_party.dart';

part 'notifications_controller.freezed.dart';
part 'notifications_controller.g.dart';

@freezed
class NotificationsControllerState with _$NotificationsControllerState {
  const factory NotificationsControllerState({
    required bool localNotificationsInitialized,
    required bool remoteNotificationsInitialized,
  }) = _NotificationsControllerState;

  factory NotificationsControllerState.initialState() => const NotificationsControllerState(
        localNotificationsInitialized: false,
        remoteNotificationsInitialized: false,
      );
}

@Riverpod(keepAlive: true)
class NotificationsController extends _$NotificationsController {
  StreamSubscription<RemoteMessage>? firebaseMessagingStreamSubscription;

  @override
  NotificationsControllerState build() {
    return NotificationsControllerState.initialState();
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
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final PermissionStatus permissionStatus = await Permission.notification.status;

    final bool hasOptedIn = sharedPreferences.getBool(kNotificationsAcceptedKey) ?? false;
    final bool isStateWhereCanRequestPermissions = permissionStatus == PermissionStatus.denied;
    final bool isIosSimulator = await systemController.isDeviceAppleSimulator();
    logger.d('canRequestPushNotificationPermissions: $hasOptedIn, $isStateWhereCanRequestPermissions, $isIosSimulator');

    return hasOptedIn && isStateWhereCanRequestPermissions && !isIosSimulator;
  }

  Future<void> setupPushNotificationListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    final bool hasPushNotificationPermissions = await this.hasPushNotificationPermissions();
    final bool isDeviceIosSimulator = await systemController.isDeviceAppleSimulator();

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
}
