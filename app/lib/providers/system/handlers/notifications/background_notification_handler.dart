// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/third_party.dart';

@pragma("vm:entry-point")
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  await notificationsController.setupLocalNotifications();
  await notificationsController.handleNewNotification(event: message, isForeground: false);
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageResponseReceived(NotificationResponse details) async {
  final logger = providerContainer.read(loggerProvider);
  logger.d('onDidReceiveBackgroundNotificationResponse: $details');
}
