import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/providers/system/handlers/notification_handler.dart';

class DefaultNotificationHandler extends NotificationHandler {
  @override
  bool canHandle(NotificationPayload payload) {
    return true;
  }
}
