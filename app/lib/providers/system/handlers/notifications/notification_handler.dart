// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/cryptography_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/jobs/profile_fetch_processor.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';

abstract class NotificationHandler {
  Logger get logger => providerContainer.read(loggerProvider);

  Future<bool> canStorePayload(NotificationPayload payload, bool isForeground) async => isForeground;

  // Handling is the ability for the handler to process the payload
  bool canHandlePayload(NotificationPayload payload, bool isForeground);

  // Display is the ability for the app to show the notification
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground);

  // Trigger is the ability for the app to trigger the notification when it is received
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async => true;

  // This is called when the notification is selected from the in app feed
  FutureOr<void> onNotificationSelected(NotificationPayload payload, BuildContext context) async => true;

  Color getBackgroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.white));
  }

  Color getForegroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.black));
  }

  bool includeTimestampOnFeed(NotificationPayload payload) {
    return false;
  }

  List<Widget> buildNotificationTrailing(PositiveNotificationTileState state) {
    logger.d('buildNotificationTrailing()');
    return [];
  }

  Widget buildNotificationLeading(PositiveNotificationTileState state) {
    final NotificationPayload payload = state.widget.notification;
    final Color foregroundColor = getForegroundColor(payload);
    final Profile? senderProfile = state.presenter.senderProfile;
    logger.d('buildNotificationLeading(), payload: $payload');

    if (senderProfile == null) {
      return const PositiveProfileCircularIndicator();
    }

    return PositiveProfileCircularIndicator(profile: senderProfile, ringColorOverride: foregroundColor);
  }

  @mustCallSuper
  Future<void> onNotificationTriggered(NotificationPayload payload, bool isForeground) async {
    if (isForeground) {
      return;
    }

    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileFetchProcessor profileFetchProcessor = await providerContainer.read(profileFetchProcessorProvider.future);
    logger.d('Loading profiles for notification: $payload');

    if (payload.sender.isNotEmpty) {
      profileFetchProcessor.appendProfileIds({payload.sender});
    }
  }

  Future<void> onNotificationDisplayed(NotificationPayload payload, bool isForeground) async {
    logger.d('onNotificationDisplayed(), payload: $payload, isForeground: $isForeground');

    if (payload.title.isEmpty || payload.body.isEmpty) {
      logger.e('onNotificationDisplayed: Unable to localize notification: $payload');
      return;
    }

    if (isForeground) {
      await displayForegroundNotification(payload);
    }

    await displayBackgroundNotification(payload);
  }

  Future<void> displayForegroundNotification(NotificationPayload payload) async {
    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext? context = appRouter.navigatorKey.currentContext;
    final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);

    // Default to background notification if no context is available
    if (context == null) {
      logger.w('displayForegroundNotification: Unable to display notification: $payload');
      return;
    }

    final PositiveNotificationSnackBar snackbar = PositiveNotificationSnackBar(payload: payload, handler: handler);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> displayBackgroundNotification(NotificationPayload payload) async {
    final logger = providerContainer.read(loggerProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = providerContainer.read(flutterLocalNotificationsPluginProvider);

    final int id = convertStringToUniqueInt(payload.id);
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        payload.topic.toTopicLocale,
        payload.topic.toTopicLocale,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: payload.topic.toTopicLocale,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    String title = payload.title;
    String body = payload.bodyMarkdown;
    if (body.isEmpty) {
      body = payload.body;
    }

    if (title.isEmpty || body.isEmpty) {
      logger.e('displayBackgroundNotification: Unable to localize notification: $payload');
      return;
    }

    // Check if we are already displaying this notification
    final List<PendingNotificationRequest> pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final bool isAlreadyDisplayed = pendingNotifications.any((element) => element.id == id);
    if (isAlreadyDisplayed) {
      logger.d('displayBackgroundNotification: Notification already displayed: $payload');
      return;
    }

    await flutterLocalNotificationsPlugin.show(id, payload.title, payload.body, notificationDetails);
    logger.d('displayBackgroundNotification: $id');
  }
}
