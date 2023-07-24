import 'dart:convert';

import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

extension RemoteMessageExtensions on RemoteMessage {
  bool get isStreamChatNotification {
    return data.containsKey('sender') && data['sender'] == 'stream.chat';
  }

  bool get isNewStreamMessage {
    return data.containsKey('type') && data['type'] == 'message.new';
  }

  NotificationPayload? get asPositivePayload {
    if (!data.containsKey('payload')) {
      return null;
    }

    final Map<String, dynamic> payloadData = json.decodeSafe(data['payload']);
    return NotificationPayload.fromJson(payloadData);
  }
}
