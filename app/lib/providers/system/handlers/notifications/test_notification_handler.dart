import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';

class TestNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    return payload.action == NotificationAction.test();
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) {
    // TODO: implement canTriggerPayload
    throw UnimplementedError();
  }
}
