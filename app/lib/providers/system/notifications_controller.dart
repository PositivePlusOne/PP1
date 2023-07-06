// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as scf;

// Project imports:
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/events/communications/notifications_updated_event.dart';
import 'package:app/providers/system/handlers/notifications/connection_request_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/default_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/relationship_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/test_notification_handler.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../constants/key_constants.dart';
import '../../dtos/database/notifications/notification_payload.dart';
import '../../dtos/database/profile/profile.dart';
import '../../main.dart';
import '../../services/third_party.dart';
import '../user/user_controller.dart';
import 'handlers/notifications/background_notification_handler.dart';

// Project imports:

part 'notifications_controller.freezed.dart';
part 'notifications_controller.g.dart';

@freezed
class NotificationsControllerState with _$NotificationsControllerState {
  const factory NotificationsControllerState({
    required bool localNotificationsInitialized,
    required bool remoteNotificationsInitialized,
    @Default({}) Map<String, NotificationPayload> notifications,
    @Default('') String notificationsCursor,
    @Default(false) bool notificationsExhausted,
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

  bool get hasNotifications => state.notifications.isNotEmpty;

  final DefaultNotificationHandler defaultNotificationHandler = DefaultNotificationHandler();
  final List<NotificationHandler> handlers = [
    ConnectionRequestNotificationHandler(),
    RelationshipNotificationHandler(),
    TestNotificationHandler(),
  ];

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
  }

  void onUserChanged(User? user) {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - User changed: $user - Resetting state');
    resetState();
  }

  void onUserProfileChanged(Profile? event) {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - User profile changed: $event - Attempting to load notifications');

    if (event == null) {
      logger.e('[Notifications Service] - User profile changed: $event - Profile is null, not loading notifications');
      state = state.copyWith(notifications: {}, notificationsCursor: '', notificationsExhausted: false);
      return;
    }
  }

  void resetNotifications() {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - Resetting notifications');
    state = state.copyWith(notifications: {}, notificationsCursor: '', notificationsExhausted: false);
  }

  Future<void> loadNextNotificationWindow() async {
    final logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    if (auth.currentUser == null) {
      logger.e('Cannot load notifications for not logged in user');
      return;
    }

    if (state.notificationsExhausted && state.notifications.isNotEmpty) {
      logger.i('Notifications exhausted, not loading more');
      return;
    }

    final Map<String, NotificationPayload> allNotifications = {
      ...state.notifications,
    };

    try {
      final HttpsCallableResult result = await functions.httpsCallable('notifications-listNotifications').call(
        <String, dynamic>{
          'cursor': state.notificationsCursor,
        },
      );

      final String strData = result.data is String ? result.data as String : '{}';
      final Map<String, dynamic> data = json.decodeSafe(strData);
      final String cursor = data['pagination']?['cursor'] ?? '';
      final List notifications = data['data'] ?? [];
      if (cursor.isNotEmpty) {
        state = state.copyWith(notificationsCursor: cursor);
      }

      if (notifications.isEmpty || notifications.length < 10) {
        state = state.copyWith(notificationsExhausted: true);
      }

      for (final dynamic data in notifications) {
        try {
          final NotificationPayload notification = NotificationPayload.fromJson(data);
          allNotifications[notification.key] = notification;
        } catch (ex) {
          logger.e('Cannot parse notification', ex);
        }
      }
    } catch (ex) {
      logger.e('Cannot load notifications', ex);
      return;
    }

    eventBus.fire(NotificationsUpdatedEvent());
    state = state.copyWith(notifications: allNotifications);
  }

  Future<void> dismissNotification(String key) async {
    final logger = ref.read(loggerProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

    final newNotifications = {...state.notifications};
    newNotifications.remove(key);
    state = state.copyWith(notifications: newNotifications);
    logger.d('Dismissed notification $key');

    logger.d('Removing from the database in the background');
    try {
      await functions.httpsCallable('notifications-dismissNotification').call(<String, dynamic>{
        'notificationKey': key,
      });
    } catch (_) {
      logger.w('Failed to remove notification from the database in the background, this might be expected.');
    }
  }

  List<NotificationPayload> getCandidateNotificationsForDisplay() {
    final logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final List<NotificationPayload> notifications = [];

    if (auth.currentUser == null) {
      logger.e('Cannot get candidate notifications for not logged in user');
      return notifications;
    }

    final currentUser = auth.currentUser;
    return state.notifications.values.where((notification) => notification.receiver == currentUser?.uid && !notification.hasDismissed && notification.title.isNotEmpty && notification.body.isNotEmpty).toList();
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
    for (final NotificationTopic topic in NotificationTopic.allTopics) {
      final String topicKey = topic.toSharedPreferencesKey;
      await sharedPreferences.setBool(topicKey, shouldEnable);
    }
  }

  // A message has been received while the app is in the foreground.
  void onRemoteNotificationReceived(RemoteMessage event) {
    final logger = ref.read(loggerProvider);
    logger.d('onRemoteNotificationReceived: $event');

    //* Check if stream chat message
    if (event.data.containsKey('sender') && event.data['sender'] == 'stream.chat') {
      logger.d('onRemoteNotificationReceived: Stream chat message, handling');
      handleStreamChatForegroundMessage(event);
      return;
    }

    if (!event.data.containsKey('payload')) {
      logger.d('onRemoteNotificationReceived: No payload, skipping');
      return;
    }

    final Map<String, dynamic> payloadData = json.decodeSafe(event.data['payload']);
    final NotificationPayload payload = NotificationPayload.fromJson(payloadData);
    appendNotification(payloadData);

    final NotificationHandler handler = getHandlerForPayload(payload);
    attemptToTriggerNotification(handler, payload, isForeground: true);
    attemptToDisplayNotification(handler, payload, isForeground: true);
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
      final String title = message.message.user?.name ?? '';
      final String body = message.message.text ?? '';

      if (title.isEmpty || body.isEmpty) {
        logger.d('handleStreamChatForegroundMessage: Invalid message: $message');
        return;
      }

      final NotificationPayload model = NotificationPayload(
        title: title,
        body: body,
        topic: const NotificationTopic.newMessage(),
      );

      if (model.title.isEmpty || model.body.isEmpty) {
        logger.d('handleStreamChatForegroundMessage: Invalid notification model: $model');
        return;
      }

      final NotificationHandler handler = getHandlerForPayload(model);
      await attemptToDisplayNotification(handler, model, isForeground: true);
    }
  }

  void appendNotification(Map<String, dynamic> data) {
    final logger = ref.read(loggerProvider);
    logger.d('attemptToParsePayload: $data');

    try {
      final NotificationPayload notification = NotificationPayload.fromJson(data);
      final Map<String, NotificationPayload> notifications = {...state.notifications};
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

  NotificationHandler getHandlerForPayload(NotificationPayload payload, {bool isForeground = true}) {
    NotificationHandler? handler = handlers.firstWhereOrNull((element) => element.canHandlePayload(payload, isForeground));
    handler ??= defaultNotificationHandler;
    return handler;
  }

  Future<void> attemptToTriggerNotification(NotificationHandler handler, NotificationPayload payload, {bool isForeground = true}) async {
    final logger = ref.read(loggerProvider);
    logger.d('attemptToTriggerNotification: $payload, $isForeground');

    if (!await handler.canTriggerPayload(payload, isForeground)) {
      return;
    }

    await handler.onNotificationTriggered(payload, isForeground);
  }

  Future<void> attemptToDisplayNotification(NotificationHandler handler, NotificationPayload payload, {bool isForeground = true}) async {
    final logger = ref.read(loggerProvider);
    logger.d('attemptToTriggerNotification: $payload, $isForeground');

    if (!await handler.canTriggerPayload(payload, isForeground)) {
      return;
    }

    await handler.onNotificationDisplayed(payload, isForeground);
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
