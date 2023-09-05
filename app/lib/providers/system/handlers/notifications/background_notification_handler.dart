// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/notifications_controller.dart';

@pragma("vm:entry-point")
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  await Firebase.initializeApp();
  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  await notificationsController.setupLocalNotifications();
  notificationsController.handleNewNotification(event: message, isForeground: false);
}
