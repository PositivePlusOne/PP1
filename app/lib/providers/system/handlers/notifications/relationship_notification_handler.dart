// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/services/third_party.dart';

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

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    if (payload.extraData.containsKey('relationship') && payload.extraData['relationship'] is Map<String, dynamic>) {
      final Map<String, dynamic> relationshipData = json.decodeSafe(payload.extraData['relationship']);
      final Relationship relationship = Relationship.fromJson(relationshipData);
      final String relationshipId = relationship.flMeta?.id ?? '';
      if (relationshipId.isEmpty) {
        logger.e('RelationshipNotificationHandler: relationshipId is empty');
        return;
      }

      cacheController.add(key: relationshipId, value: relationship, metadata: relationship.flMeta);
    }
  }

  @override
  Future<void> onNotificationDisplayed(NotificationPayload payload, bool isForeground) async {
    // Do nothing! These cannot be displayed.
  }
}
