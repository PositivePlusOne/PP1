// Dart imports:
import 'dart:async';

// Package imports:
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as scf;

// Project imports:
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/notification_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/handlers/notifications/activity_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/connection_request_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/default_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/new_message_notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/handlers/notifications/relationship_notification_handler.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/state/positive_notifications_state.dart';
import '../../constants/key_constants.dart';
import '../../dtos/database/notifications/notification_payload.dart';
import '../../dtos/database/profile/profile.dart';
import '../../main.dart';
import '../../services/third_party.dart';
import '../user/user_controller.dart';
import 'handlers/notifications/background_notification_handler.dart';

part 'notifications_controller.freezed.dart';
part 'notifications_controller.g.dart';

@freezed
class NotificationsControllerState with _$NotificationsControllerState {
  const factory NotificationsControllerState({
    required bool localNotificationsInitialized,
    required bool remoteNotificationsInitialized,
    DateTime? lastNotificationReceivedTime,
    DateTime? lastNotificationCheckTime,
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

  static const String kNotificationReceivedTimeKey = 'notificationReceivedTime';
  static const String kNotificationCheckTimeKey = 'notificationCheckTime';

  bool get canDisplayNotificationFeedBadge {
    final DateTime? lastNotificationReceivedTime = state.lastNotificationReceivedTime;
    DateTime? lastNotificationCheckTime = state.lastNotificationCheckTime;

    if (lastNotificationReceivedTime == null) {
      return false;
    }

    // If we have no last notification check time, we can assume we have never checked
    lastNotificationCheckTime ??= DateTime(0);

    final bool hasReceivedNotificationRecently = lastNotificationReceivedTime.isAfter(lastNotificationCheckTime);
    return hasReceivedNotificationRecently;
  }

  final DefaultNotificationHandler defaultNotificationHandler = DefaultNotificationHandler();
  final List<NotificationHandler> handlers = [
    ConnectionRequestNotificationHandler(),
    RelationshipNotificationHandler(),
    NewMessageNotificationHandler(),
    ActivityNotificationHandler(),
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
    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);
  }

  void onUserChanged(User? user) {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - User changed: $user - Resetting state');
    resetState();
  }

  void resetNotifications() {
    final logger = ref.read(loggerProvider);
    logger.i('[Notifications Service] - Resetting notifications');
  }

  Future<void> fetchNotificationCheckTime() async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    final String? notificationCheckTimeString = sharedPreferences.getString(kNotificationCheckTimeKey);
    final DateTime? notificationCheckTime = DateTime.tryParse(notificationCheckTimeString ?? '');

    if (notificationCheckTime == null) {
      logger.d('fetchNotificationCheckTime: No notification check time found');
      return;
    }

    logger.d('fetchNotificationCheckTime: $notificationCheckTime');
    state = state.copyWith(lastNotificationCheckTime: notificationCheckTime);
  }

  Future<void> fetchNotificationReceivedTime() async {
    final logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    final String? notificationReceivedTimeString = sharedPreferences.getString(kNotificationReceivedTimeKey);
    final DateTime? notificationReceivedTime = DateTime.tryParse(notificationReceivedTimeString ?? '');

    if (notificationReceivedTime == null) {
      logger.d('fetchNotificationReceivedTime: No notification received time found');
      return;
    }

    logger.d('fetchNotificationReceivedTime: $notificationReceivedTime');
    state = state.copyWith(lastNotificationReceivedTime: notificationReceivedTime);
  }

  Future<void> updateNotificationCheckTime() async {
    final logger = providerContainer.read(loggerProvider);
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);

    final DateTime now = DateTime.now();
    await sharedPreferences.setString(kNotificationCheckTimeKey, now.toIso8601String());
    logger.d('updateNotificationCheckTime: $now');

    state = state.copyWith(lastNotificationCheckTime: now);
  }

  Future<void> updateNotificationReceivedTime() async {
    final logger = providerContainer.read(loggerProvider);
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);

    final DateTime now = DateTime.now();
    await sharedPreferences.setString(kNotificationReceivedTimeKey, now.toIso8601String());
    logger.d('updateNotificationReceivedTime: $now');

    state = state.copyWith(lastNotificationReceivedTime: now);
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

    if (state.localNotificationsInitialized) {
      logger.d('setupPushNotificationListeners: Already initialized');
      return;
    }

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
      await setupLocalNotifications();
      logger.d('setupPushNotificationListeners: Initialized local notifications');
    }

    if (!state.remoteNotificationsInitialized) {
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
      firebaseMessagingStreamSubscription = FirebaseMessaging.onMessage.listen(onForegroundNotificationReceived);

      logger.d('setupPushNotificationListeners: Subscribed to remote notifications');
      state = state.copyWith(remoteNotificationsInitialized: true);
    }
  }

  Future<void> setupLocalNotifications() async {
    final logger = providerContainer.read(loggerProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = providerContainer.read(flutterLocalNotificationsPluginProvider);

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: onLocalNotificationReceived);
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, macOS: initializationSettingsDarwin, linux: initializationSettingsLinux);
    final bool? initializedSuccessfully = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onBackgroundMessageResponseReceived,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    state = state.copyWith(localNotificationsInitialized: initializedSuccessfully ?? false);
    logger.d('setupPushNotificationListeners: Initialized local notifications: $initializedSuccessfully');
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

  void onForegroundNotificationReceived(RemoteMessage event) {
    final logger = ref.read(loggerProvider);
    logger.d('onRemoteNotificationReceived: $event');

    handleNewNotification(event: event, isForeground: true);
  }

  Future<void> handleNewNotification({
    required RemoteMessage event,
    bool isForeground = false,
  }) async {
    final logger = providerContainer.read(loggerProvider);
    await updateNotificationReceivedTime();

    if (event.isStreamChatNotification && !isForeground) {
      logger.d('onRemoteNotificationReceived: Stream chat message, handling');
      await handleStreamChatMessage(event: event, isForeground: isForeground);
      return;
    }

    final NotificationPayload? payload = event.asPositivePayload;
    if (payload != null) {
      logger.d('onRemoteNotificationReceived: Positive notification, handling');
      await handleNotification(payload, isForeground: isForeground);
    } else {
      logger.w('onRemoteNotificationReceived: Unknown notification, skipping: $event');
    }
  }

  Future<void> handleStreamChatMessage({
    required RemoteMessage event,
    bool isForeground = false,
  }) async {
    final logger = providerContainer.read(loggerProvider);
    final scf.StreamChatClient streamChatClient = providerContainer.read(streamChatClientProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final AppRouter appRouter = providerContainer.read(appRouterProvider);

    if (!event.isNewStreamMessage) {
      logger.d('handleStreamChatForegroundMessage: Not a new message, skipping');
      return;
    }

    logger.d('handleStreamChatForegroundMessage: New message received, handling');
    final String id = event.data['id'] ?? '';
    String title = event.data['title'] ?? '';
    String body = event.data['body'] ?? '';

    if (isForeground && id.isNotEmpty) {
      final AppLocalizations localizations = AppLocalizations.of(appRouter.navigatorKey.currentContext!)!;
      final scf.GetMessageResponse messageResponse = await streamChatClient.getMessage(id);
      final String senderId = messageResponse.message.user?.id ?? '';
      final Profile senderProfile = await profileController.getProfile(senderId);

      title = senderProfile.displayName.asHandle;
      body = messageResponse.message.getFormattedDescription(localizations);
    }

    if (title.isEmpty || body.isEmpty) {
      logger.e('handleStreamChatForegroundMessage: Title or body is empty');
      return;
    }

    final NotificationPayload model = NotificationPayload(
      id: id,
      title: title,
      body: body,
      topic: const NotificationTopic.newMessage(),
    );

    await handleNotification(model, isForeground: isForeground);
  }

  Future<void> handleNotification(NotificationPayload payload, {bool isForeground = false}) async {
    final logger = providerContainer.read(loggerProvider);
    final NotificationHandler handler = getHandlerForPayload(payload);
    logger.d('attemptToParsePayload: $payload');

    try {
      if (isForeground) {
        await attemptToStoreNotificationPayloadInFeed(payload, isForeground);
        await attemptToTriggerNotification(handler, payload, isForeground: isForeground);
      }

      await attemptToDisplayNotification(handler, payload, isForeground: isForeground);
    } catch (e) {
      logger.e('attemptToParsePayload: Failed to parse payload');
    }
  }

  PositiveNotificationsState getOrCreateNotificationCacheState(String uid) {
    final logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String expectedCacheKey = 'notifications:$uid';

    logger.d('createInitialNotificationCacheState: $uid');

    PositiveNotificationsState? notificationsState = cacheController.get(expectedCacheKey);
    if (notificationsState != null) {
      logger.d('createInitialNotificationCacheState: Already has cache state, skipping');
      return notificationsState;
    }

    notificationsState = PositiveNotificationsState(
      uid: uid,
      pagingController: PagingController<String, NotificationPayload>(firstPageKey: ''),
      currentPaginationKey: '',
      unreadCount: 0,
      unseenCount: 0,
      hasFirstLoad: false,
    );

    cacheController.add(key: expectedCacheKey, value: notificationsState);
    return notificationsState;
  }

  void onLocalNotificationReceived(int id, String? title, String? body, String? payload) {
    final logger = providerContainer.read(loggerProvider);
    logger.d('onLocalNotificationReceived: $id, $title, $body, $payload');
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
    final logger = providerContainer.read(loggerProvider);
    logger.d('attemptToTriggerNotification: $payload, $isForeground');

    if (!await handler.canDisplayPayload(payload, isForeground)) {
      return;
    }

    await handler.onNotificationDisplayed(payload, isForeground);
  }

  Future<void> attemptToStoreNotificationPayloadInFeed(NotificationPayload payload, bool isForeground) async {
    if (!isForeground) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final PositiveNotificationsState notificationsState = getOrCreateNotificationCacheState(payload.userId);

    final String groupId = payload.groupId;
    if (groupId.isNotEmpty) {
      // We need to do some checks, as if we can group match
      // We need to remove the old one and add the new one
      final bool hasGroupMatch = notificationsState.knownGroups.contains(groupId);
      if (hasGroupMatch) {
        logger.d('attemptToStoreNotificationPayloadInFeed: Has group match, removing old notification');
        notificationsState.pagingController.itemList?.removeWhere((element) => element.groupId == groupId);
      }
    }

    logger.d('attemptToStoreNotificationPayloadInFeed: $payload, $isForeground');
    notificationsState.pagingController.insertItem(0, payload);

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String cacheKey = notificationsState.buildCacheKey();

    cacheController.add(key: cacheKey, value: notificationsState);
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
