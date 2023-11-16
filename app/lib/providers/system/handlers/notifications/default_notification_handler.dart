// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';

class DefaultNotificationHandler extends NotificationHandler {
  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    return true;
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return payload.title.isNotEmpty && payload.body.isNotEmpty;
  }
}
