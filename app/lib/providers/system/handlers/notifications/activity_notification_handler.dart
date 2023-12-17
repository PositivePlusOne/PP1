// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';

class ActivityNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    final bool isComment = payload.action == const NotificationAction.postCommented() || payload.action == const NotificationAction.postCommentedGrouped();
    final bool isLike = payload.action == const NotificationAction.postLiked() || payload.action == const NotificationAction.postLikedGrouped();
    final bool isShare = payload.action == const NotificationAction.postShared() || payload.action == const NotificationAction.postSharedGrouped();
    final bool isBookmark = payload.action == const NotificationAction.postBookmarked() || payload.action == const NotificationAction.postBookmarkedGrouped();
    final bool isMention = payload.action == const NotificationAction.postMentioned();

    return isComment || isLike || isShare || isBookmark || isMention;
  }

  bool isGrouped(NotificationPayload payload) {
    return payload.action == const NotificationAction.postCommentedGrouped() || payload.action == const NotificationAction.postLikedGrouped() || payload.action == const NotificationAction.postSharedGrouped() || payload.action == const NotificationAction.postBookmarkedGrouped();
  }

  @override
  bool includeTimestampOnFeed(NotificationPayload payload) {
    return true;
  }

  @override
  Color getBackgroundColor(NotificationPayload payload) {
    final String sender = payload.sender;
    if (sender.isNotEmpty) {
      final CacheController cacheController = providerContainer.read(cacheControllerProvider);
      final Profile? profile = cacheController.get(sender);
      if (profile != null) {
        return profile.accentColor.toSafeColorFromHex();
      }
    }

    return providerContainer.read(designControllerProvider.select((value) => value.colors.pink));
  }

  @override
  Color getForegroundColor(NotificationPayload payload) {
    return getBackgroundColor(payload).complimentTextColor;
  }

  IconData getIconData(NotificationPayload payload) {
    return payload.action.when(
      postCommented: () => UniconsLine.chat,
      postCommentedGrouped: () => UniconsLine.chat,
      postLiked: () => UniconsLine.heart_alt,
      postLikedGrouped: () => UniconsLine.heart_alt,
      postShared: () => UniconsLine.share_alt,
      postSharedGrouped: () => UniconsLine.share_alt,
      postBookmarked: () => UniconsLine.bookmark,
      postBookmarkedGrouped: () => UniconsLine.bookmark,
      postMentioned: () => UniconsLine.comment_lines,
      none: () => UniconsLine.exclamation_triangle,
      test: () => UniconsLine.exclamation_triangle,
      connectionRequestAccepted: () => UniconsLine.exclamation_triangle,
      connectionRequestRejected: () => UniconsLine.exclamation_triangle,
      connectionRequestSent: () => UniconsLine.exclamation_triangle,
      connectionRequestReceived: () => UniconsLine.exclamation_triangle,
      relationshipUpdated: () => UniconsLine.exclamation_triangle,
    );
  }

  @override
  Widget buildNotificationLeading(PositiveNotificationTileState state) {
    final NotificationPayload payload = state.presenter.payload;
    final bool groupPayload = isGrouped(payload);

    if (!groupPayload) {
      return super.buildNotificationLeading(state);
    }

    final Color backgroundColor = getBackgroundColor(payload);
    final Color foregroundColor = backgroundColor.complimentTextColor;
    final IconData iconData = getIconData(payload);

    return PositiveCircularIndicator(
      backgroundColor: backgroundColor,
      ringColor: foregroundColor,
      child: Icon(iconData, color: foregroundColor),
    );
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

    // Preload the activity
    await activitiesController.getActivity(activityId);

    final AppRouter router = providerContainer.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activityId: activityId,
      feed: TargetFeed.fromOrigin(origin),
    );

    await router.push(postRoute);
  }
}
