// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';

Future<void> updateUserMixpanelProperties({
  required bool isCollectingData,
}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final UserController userController = providerContainer.read(userControllerProvider.notifier);
  final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider);
  final Mixpanel mixpanel = await providerContainer.read(mixpanelProvider.future);

  if (!isCollectingData) {
    logger.d('updateUserProperties: Analytics is disabled, not updating user properties');
    return;
  }

  final Map<String, dynamic> properties = {};

  // Add notification topics
  final Set<String> topics = await notificationsController.getSubscribedTopics();
  final Set<NotificationTopic> allTopics = NotificationTopic.allTopics;
  final Set<NotificationTopic> currentNotificationTopics = topics.map((String topic) => NotificationTopic.fromJson(topic)).toSet();
  for (final NotificationTopic notificationTopic in allTopics) {
    final bool isSubscribed = currentNotificationTopics.contains(notificationTopic);
    properties['NotificationTopic${NotificationTopic.toPascalCase(notificationTopic)}'] = isSubscribed;
  }

  final User? currentUser = userController.currentUser;
  final String currentUserId = currentUser?.uid ?? '';

  if (currentUserId.isEmpty) {
    logger.d('updateUserProperties: No user ID, not updating user properties');
    mixpanel.identify('');
    return;
  }

  if (currentUser != null) {
    properties['UserId'] = currentUser.uid;
    properties['EmailAddress'] = currentUser.email;
  }

  final Profile? profile = profileController.currentProfile;
  if (profile != null) {
    properties['ProfileId'] = profile.flMeta?.id ?? 'unknown';
    properties['ProfileDisplayName'] = profile.displayName;
    properties['ProfileIsOrganisation'] = profile.isOrganisation;

    final String expectedStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: profile.flMeta?.id ?? '');
    final ProfileStatistics? profileStatistics = cacheController.get<ProfileStatistics>(expectedStatisticsKey);
    if (profileStatistics != null) {
      properties['ProfileFollowers'] = profileStatistics.followers;
      properties['ProfileFollowing'] = profileStatistics.following;
      properties['ProfilePosts'] = profileStatistics.posts;
      properties['ProfileLikes'] = profileStatistics.likes;
      properties['ProfileShares'] = profileStatistics.shares;
    }
  }

  // This API is pretty weird????
  final People people = mixpanel.getPeople();
  mixpanel.identify(currentUserId);

  for (final MapEntry<String, dynamic> property in properties.entries) {
    people.set(property.key, property.value);
  }

  logger.d('updateUserProperties: Updated user properties: $properties');
}
