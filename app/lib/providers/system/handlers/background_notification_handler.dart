// Package imports:
import 'package:app/providers/system/handlers/notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/notifications_controller.dart';

@pragma("vm:entry-point")
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  await Firebase.initializeApp();

  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  if (message.data.containsKey('payload') && message.data['payload'] is String) {
    final NotificationPayload payload = NotificationPayload.fromJson(message.data['payload']);
    final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);
    await notificationsController.attemptToDisplayNotification(handler, payload, isForeground: false);
  }
}
