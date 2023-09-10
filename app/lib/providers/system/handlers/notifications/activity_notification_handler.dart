// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/services/third_party.dart';

class ActivityNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    final bool isComment = payload.action == const NotificationAction.postCommented();
    final bool isLike = payload.action == const NotificationAction.postLiked();
    final bool isShare = payload.action == const NotificationAction.postShared();

    return isComment || isLike || isShare;
  }

  @override
  bool includeTimestampOnFeed(NotificationPayload payload) {
    return true;
  }

  @override
  FutureOr<void> onNotificationSelected(NotificationPayload payload, BuildContext context) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final String activityId = payload.extraData.containsKey('activity_id') ? payload.extraData['activity_id'] as String : '';
    final String reactionId = payload.extraData.containsKey('reaction_id') ? payload.extraData['reaction_id'] as String : '';
    final String origin = payload.extraData.containsKey('origin') ? payload.extraData['origin'] as String : '';

    if (activityId.isEmpty || reactionId.isEmpty || origin.isEmpty) {
      logger.e('onNotificationSelected(), activityId, reactionId or feed is empty');
      return;
    }

    final Activity activity = await activitiesController.getActivity(activityId);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: activity,
      feed: TargetFeed.fromOrigin(origin),
    );

    await router.push(postRoute);
  }

  @override
  Color getBackgroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.pink));
  }

  @override
  Color getForegroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.black));
  }
}
