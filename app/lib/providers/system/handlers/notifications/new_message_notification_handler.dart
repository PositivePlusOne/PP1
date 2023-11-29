// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';

class NewMessageNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    final AppRouter router = providerContainer.read(appRouterProvider);
    final bool isChatPage = router.current.name == ChatRoute.name;

    return !isChatPage;
  }

  @override
  Future<bool> canStorePayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    return payload.topic == const NotificationTopic.newMessage();
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }
}
