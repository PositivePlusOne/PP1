// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';

extension NotifierProviderRefExt on NotifierProviderRef {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
  }
}

extension WidgetRefExt on WidgetRef {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
  }
}

void cacheProfileData(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> profiles = (data.containsKey('users') ? data['users'] : []).map((dynamic profile) => profile as Map<String, dynamic>).toList();
  final List<Profile> newProfiles = [];

  for (final dynamic profile in profiles) {
    try {
      logger.d('requestNextTimelinePage() - parsing profile: $profile');
      final Profile newProfile = Profile.fromJson(profile);
      final String profileId = newProfile.flMeta?.id ?? '';
      if (profileId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache profile: $profile');
        continue;
      }

      newProfiles.add(newProfile);
      cacheController.addToCache(profileId, newProfile);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache profile: $profile - ex: $ex');
    }
  }
}

void cacheActivityData(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<Activity> newActivities = [];
  final List<dynamic> activities = (data.containsKey('activities') ? data['activities'] : []).map((dynamic activity) => activity as Map<String, dynamic>).toList();

  for (final dynamic activity in activities) {
    try {
      logger.d('requestNextTimelinePage() - parsing activity: $activity');
      final Activity newActivity = Activity.fromJson(activity);
      final String activityId = newActivity.flMeta?.id ?? '';
      if (activityId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache activity: $activity');
        continue;
      }

      newActivities.add(newActivity);
      cacheController.addToCache(activityId, newActivity);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache activity: $activity - ex: $ex');
    }
  }

  logger.d('requestNextTimelinePage() - newActivities: $newActivities');
}
