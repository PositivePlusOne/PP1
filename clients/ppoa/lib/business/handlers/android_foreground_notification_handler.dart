// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

StreamSubscription<RemoteMessage>? _androidMessageSubscription;

Future<void> configureAndroidForegroundMessages({
  required AndroidNotificationChannel channel,
  required FlutterLocalNotificationsPlugin notificationsPlugin,
}) async {
  await _androidMessageSubscription?.cancel();

  _androidMessageSubscription = FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification == null || android == null) {
        return;
      }

      notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    },
  );
}
