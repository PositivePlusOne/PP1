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

  bool canHandlePayload(NotificationPayload payload, bool isForeground);
  Future<bool> canStorePayload(NotificationPayload payload, bool isForeground) async => isForeground;
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground);
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async => true;

  Color getBackgroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.white));
  }

  Color getForegroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.black));
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

    if (payload.receiver.isNotEmpty) {
      profileFetchProcessor.appendProfileIds({payload.receiver});
    }
  }

  Future<void> onNotificationDisplayed(NotificationPayload payload, bool isForeground) async {
    logger.d('onNotificationDisplayed(), payload: $payload, isForeground: $isForeground');

    if (payload.title.isEmpty || payload.body.isEmpty) {
      logger.e('onNotificationDisplayed: Unable to localize notification: $payload');
      return;
    }

    if (isForeground) {
      displayForegroundNotification(payload);
    } else {
      displayBackgroundNotification(payload);
    }
  }

  Future<void> displayForegroundNotification(NotificationPayload payload) async {
    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext? context = appRouter.navigatorKey.currentContext;
    final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);

    // Default to background notification if no context is available
    if (context == null) {
      logger.w('displayForegroundNotification: Unable to display notification: $payload');
      await displayBackgroundNotification(payload);
      return;
    }

    final PositiveNotificationSnackBar snackbar = PositiveNotificationSnackBar(payload: payload, handler: handler);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> displayBackgroundNotification(NotificationPayload payload) async {
    final logger = providerContainer.read(loggerProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = providerContainer.read(flutterLocalNotificationsPluginProvider);

    final int id = convertStringToUniqueInt(payload.key);
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        payload.topic.toLocalizedTopic,
        payload.topic.toLocalizedTopic,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: payload.topic.toLocalizedTopic,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    if (payload.title.isEmpty || payload.body.isEmpty) {
      logger.e('displayBackgroundNotification: Unable to localize notification: $payload');
      return;
    }

    await flutterLocalNotificationsPlugin.show(id, payload.title, payload.body, notificationDetails);
    logger.d('displayBackgroundNotification: $id');
  }
}
