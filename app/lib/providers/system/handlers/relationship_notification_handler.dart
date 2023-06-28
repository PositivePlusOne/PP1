import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/handlers/notification_handler.dart';
import 'package:app/providers/user/relationship_controller.dart';

class RelationshipNotificationHandler extends NotificationHandler {
  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    if (!isForeground) {
      return false;
    }

    return payload.action == const NotificationAction.relationshipUpdated();
  }

  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  Future<void> onNotificationTriggered(NotificationPayload payload, bool isForeground) async {
    await super.onNotificationTriggered(payload, isForeground);

    final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
    if (payload.extraData.containsKey('relationship') && payload.extraData['relationship'] is Map<String, dynamic>) {
      relationshipController.appendRelationship(payload.extraData['relationship']);
    }
  }

  @override
  Future<void> onNotificationDisplayed(NotificationPayload payload, bool isForeground) async {
    // Do nothing! These cannot be displayed.
  }
}
