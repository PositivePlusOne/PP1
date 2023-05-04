// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as scf;

// Project imports:
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/models/positive_notification_model.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import '../../constants/key_constants.dart';
import '../../dtos/database/notifications/user_notification.dart';
import '../../dtos/database/profile/profile.dart';
import '../../enumerations/positive_notification_topic.dart';
import '../../enumerations/positive_notification_type.dart';
import '../../extensions/future_extensions.dart';
import '../../main.dart';
import '../../services/third_party.dart';
import '../user/user_controller.dart';
import 'handlers/background_notification_handler.dart';

// Project imports:

part 'notifications_controller.freezed.dart';
part 'notifications_controller.g.dart';

@freezed
class NotificationsControllerState with _$NotificationsControllerState {
  const factory NotificationsControllerState({
    required bool localNotificationsInitialized,
    required bool remoteNotificationsInitialized,
    @Default({}) Map<String, UserNotification> notifications,
  }) = _NotificationsControllerState;

  factory NotificationsControllerState.initialState() => const NotificationsControllerState(
        localNotificationsInitialized: false,
        remoteNotificationsInitialized: false,
      );
}

@Riverpod(keepAlive: true)
class NotificationsController extends _$NotificationsController {
  StreamSubscription<RemoteMessage>? firebaseMessagingStreamSubscription;
  StreamSubscription<User?>? userSubscription;
  StreamSubscription<Profile?>? userProfileSubscription;

  @override
  NotificationsControllerState build() {
    return NotificationsControllerState.initialState();
  }

  void resetState() {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - Resetting state');
    state = NotificationsControllerState.initialState();
  }

  Future<void> setupListeners() async {
    await userSubscription?.cancel();
    await userProfileSubscription?.cancel();

    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);
    userProfileSubscription = ref.read(profileControllerProvider.notifier).userProfileStreamController.stream.listen(onUserProfileChanged);
  }

  void onUserChanged(User? user) {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - User changed: $user - Resetting state');
    resetState();
  }

  void onUserProfileChanged(Profile? event) {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - User profile changed: $event - Attempting to load notifications');

    failSilently(ref, () => updateNotifications());
  }

  Future<void> updateNotifications() async {
    final logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('Cannot load notifications for not logged in user');
      return;
    }

    final HttpsCallableResult result = await functions.httpsCallable('notifications-listNotifications').call();
    if (result.data == null) {
      logger.e('Cannot load notifications for not logged in user');
      return;
    }

    final Map<String, UserNotification> notifications = {};
    final Map<String, dynamic> data = json.decodeSafe(result.data as String);
    for (final dynamic item in data.values) {
      try {
        final UserNotification notification = UserNotification.fromJson(item as Map<String, dynamic>);
        notifications[notification.key] = notification;
      } catch (e) {
        logger.e('Cannot parse notification', e);
      }
    }

    state = state.copyWith(notifications: notifications);
  }

  Future<void> resetNotifications() async {
    final logger = ref.read(loggerProvider);

    logger.d('Reset notifications');
    state = state.copyWith(notifications: {});
  }

  Future<void> dismissNotification(String key) async {
    final logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('Cannot dismiss notification for not logged in user');
      return;
    }

    await functions.httpsCallable('notifications-dismissNotification').call(<String, dynamic>{
      'notificationKey': key,
    });

    final newNotifications = {...state.notifications};
    newNotifications.remove(key);

    logger.d('Dismissed notification $key');
    state = state.copyWith(notifications: newNotifications);
  }

  Future<bool> requestPushNotificationPermissions() async {
    final logger = ref.read(loggerProvider);
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
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final PermissionStatus permissionStatus = await Permission.notification.status;

    final bool hasOptedIn = sharedPreferences.getBool(kNotificationsAcceptedKey) ?? false;

    logger.d('hasPushNotificationPermissions: $hasOptedIn, $permissionStatus');
    return (permissionStatus.isGranted || permissionStatus.isLimited) && hasOptedIn;
  }

  Future<bool> canRequestPushNotificationPermissions() async {
    final logger = ref.read(loggerProvider);
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
    final logger = ref.read(loggerProvider);
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
    final bool isDeviceAndroid = await ref.read(deviceInfoProvider.future).then((deviceInfo) => deviceInfo is AndroidDeviceInfo);
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

    //* Here we add the background handler, it is concrete which means testing is a pain.
    if (isDeviceAndroid || isDeviceIos) {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
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

  Future<void> toggleTopicPreferences(bool shouldEnable) async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    logger.d('toggleTopicPreferences: $shouldEnable');
    for (final PositiveNotificationTopic topic in PositiveNotificationTopic.values) {
      final String topicKey = topic.toSharedPreferencesKey;
      await sharedPreferences.setBool(topicKey, shouldEnable);
    }
  }

  void onRemoteNotificationReceived(RemoteMessage event) {
    final logger = ref.read(loggerProvider);
    logger.d('onRemoteNotificationReceived: $event');

    //* Check if stream chat message
    if (event.data.containsKey('sender') && event.data['sender'] == 'stream.chat') {
      logger.d('onRemoteNotificationReceived: Stream chat message, handling');
      handleStreamChatForegroundMessage(event);
      return;
    }

    final PositiveNotificationModel positiveNotificationModel = PositiveNotificationModel.fromRemoteMessage(event);
    if (positiveNotificationModel.title.isEmpty || positiveNotificationModel.body.isEmpty) {
      logger.d('onRemoteNotificationReceived: Invalid notification model: $positiveNotificationModel');
      return;
    }

    //* Convert the payload to a UserNotification and store in the controller
    attemptToParsePayload(event.data);

    //* This will only be called in the foreground
    handleNotificationAction(positiveNotificationModel, isBackground: false);
    displayForegroundNotification(positiveNotificationModel);
  }

  Future<void> handleStreamChatForegroundMessage(RemoteMessage event) async {
    final logger = ref.read(loggerProvider);
    final scf.StreamChatClient streamChatClient = ref.read(streamChatClientProvider);

    if (streamChatClient.wsConnectionStatus != scf.ConnectionStatus.connected) {
      logger.d('handleStreamChatForegroundMessage: Stream chat client not connected, skipping message handling');
      return;
    }

    if (event.data.containsKey('type') && event.data['type'] == 'message.new') {
      logger.d('handleStreamChatForegroundMessage: New message received, handling');
      final String messageId = event.data['id'] ?? '';
      final scf.GetMessageResponse message = await streamChatClient.getMessage(messageId);
      final PositiveNotificationModel model = PositiveNotificationModel.fromMessage(message);
      if (model.title.isEmpty || model.body.isEmpty) {
        logger.d('handleStreamChatForegroundMessage: Invalid notification model: $model');
        return;
      }

      await displayForegroundNotification(model);
    }
  }

  void attemptToParsePayload(Map<String, dynamic> data) {
    final logger = ref.read(loggerProvider);
    logger.d('attemptToParsePayload: $data');

    try {
      final UserNotification notification = UserNotification.fromJson(data);
      final Map<String, UserNotification> notifications = {...state.notifications};
      notifications[notification.key] = notification;

      state = state.copyWith(notifications: notifications);
    } catch (_) {
      logger.d('attemptToParsePayload: Failed to parse payload: $data');
    }
  }

  void onLocalNotificationReceived(int id, String? title, String? body, String? payload) {
    final logger = ref.read(loggerProvider);
    logger.d('onLocalNotificationReceived: $id, $title, $body, $payload');
  }

  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
    final logger = providerContainer.read(loggerProvider);
    logger.d('onDidReceiveBackgroundNotificationResponse: $details');
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    final logger = ref.read(loggerProvider);
    logger.d('onDidReceiveNotificationResponse: $details');
  }

  Future<void> handleNotificationAction(PositiveNotificationModel model, {bool isBackground = true}) async {
    final logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.d('handleNotificationAction: $model, $isBackground');

    //* Check for any potential changes to the user's relationship status with other users
    await relationshipController.handleNotificationAction(model, isBackground: isBackground);
  }

  Future<bool> canDisplayNotification(PositiveNotificationModel model) async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final PositiveNotificationTopic notificationTopic = notificationTopicFromKey(model.topic);

    logger.d('canDisplayNotification: $model');

    final bool topicEnabled = sharedPreferences.getBool(notificationTopic.toSharedPreferencesKey) ?? true;
    if (!topicEnabled) {
      logger.d('canDisplayNotification: Topic disabled, ignoring');
      return false;
    }

    return true;
  }

  Future<void> displayForegroundNotification(PositiveNotificationModel model) async {
    final logger = ref.read(loggerProvider);
    logger.d('displayForegroundNotification: $model');

    if (!await canDisplayNotification(model)) {
      return;
    }

    // TODO(ryan): implement this
    await displayBackgroundNotification(model);
  }

  Future<void> displayBackgroundNotification(PositiveNotificationModel model) async {
    final logger = ref.read(loggerProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = ref.read(flutterLocalNotificationsPluginProvider);
    final PositiveNotificationTopic notificationTopic = notificationTopicFromKey(model.topic);

    if (model.type == PositiveNotificationType.typeData.value) {
      logger.d('displayBackgroundNotification: Data notification, ignoring');
      return;
    }

    if (!await canDisplayNotification(model)) {
      return;
    }

    final int id = int.tryParse(model.key) ?? 0;
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        notificationTopic.toLocalizedTopic,
        notificationTopic.toLocalizedTopic,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: notificationTopic.toLocalizedTopic,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    if (model.title.isEmpty || model.body.isEmpty) {
      logger.e('displayBackgroundNotification: Unable to localize notification: $model');
      return;
    }

    await flutterLocalNotificationsPlugin.show(id, model.title, model.body, notificationDetails);
    logger.d('displayBackgroundNotification: $id');
  }

  Future<bool> isSubscribedToTopic(String sharedPreferencesKey) async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final bool? isSubscribed = sharedPreferences.getBool(sharedPreferencesKey);
    logger.d('isSubscribedToTopic: $sharedPreferencesKey, $isSubscribed');
    return isSubscribed ?? false;
  }

  Future<void> subscribeToTopic(String topicKey, String sharedPreferencesKey) async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    final bool? isSubscribed = sharedPreferences.getBool(sharedPreferencesKey);
    logger.d('subscribeToTopic: $topicKey, $isSubscribed');

    await sharedPreferences.setBool(sharedPreferencesKey, true);
    logger.d('subscribeToTopic: Subscribed to $topicKey');
  }

  Future<void> unsubscribeFromTopic(String topicKey, String sharedPreferencesKey) async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    final bool? isSubscribed = sharedPreferences.getBool(sharedPreferencesKey);
    logger.d('unsubscribeFromTopic: $topicKey, $isSubscribed');

    await sharedPreferences.setBool(sharedPreferencesKey, false);
    logger.d('unsubscribeFromTopic: Unsubscribed from $topicKey');
  }
}
