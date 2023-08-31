// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import '../dtos/database/activities/tags.dart';
import '../dtos/database/relationships/relationship.dart';

extension ProviderContainerExt on ProviderContainer {
  void cacheResponseData(Map<String, dynamic> data, Map<String, bool> overwriteCache) {
    cacheProfileData(data, overwriteCache["users"] ?? true);
    cacheActivityData(data, overwriteCache["activities"] ?? true);
    cacheRelationshipData(data, overwriteCache["relationships"] ?? true);
    cacheTagData(data, overwriteCache["tags"] ?? true);
    cacheGuidanceDirectoryEntries(data, overwriteCache["guidanceDirectoryEntries"] ?? true);
  }
}

extension AutoDisposeFutureProviderRefExt on AutoDisposeFutureProviderRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheActivityData(data, overwriteCache);
    cacheRelationshipData(data, overwriteCache);
    cacheTagData(data, overwriteCache);
    cacheGuidanceDirectoryEntries(data, overwriteCache);
  }
}

extension NotifierProviderRefExt on NotifierProviderRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheActivityData(data, overwriteCache);
    cacheRelationshipData(data, overwriteCache);
    cacheTagData(data, overwriteCache);
    cacheGuidanceDirectoryEntries(data, overwriteCache);
  }
}

extension WidgetRefExt on WidgetRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheActivityData(data, overwriteCache);
    cacheRelationshipData(data, overwriteCache);
    cacheTagData(data, overwriteCache);
    cacheGuidanceDirectoryEntries(data, overwriteCache);
  }
}

void cacheProfileData(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> profiles = (data.containsKey('users') ? data['users'] : []).map((dynamic profile) => json.decodeSafe(profile)).toList();

  for (final dynamic profile in profiles) {
    try {
      logger.d('requestNextTimelinePage() - parsing profile: $profile');
      final Profile newProfile = Profile.fromJson(profile);
      final String profileId = newProfile.flMeta?.id ?? '';
      if (profileId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache profile: $profile');
        continue;
      }

      cacheController.addToCache(key: profileId, value: newProfile, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache profile: $profile - ex: $ex');
    }
  }
}

void cacheActivityData(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> activities = (data.containsKey('activities') ? data['activities'] : []).map((dynamic activity) => json.decodeSafe(activity)).toList();

  for (final dynamic activity in activities) {
    try {
      logger.d('requestNextTimelinePage() - parsing activity: $activity');
      final Activity newActivity = Activity.fromJson(activity);
      final String activityId = newActivity.flMeta?.id ?? '';
      if (activityId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache activity: $activity');
        continue;
      }

      if (newActivity.enrichmentConfiguration?.originFeed.isNotEmpty ?? false) {
        cacheReactionStatisticsData(
          feed: newActivity.enrichmentConfiguration?.originFeed ?? '',
          reactionCounts: newActivity.enrichmentConfiguration?.reactionCounts ?? {},
          activityId: activityId,
          overwriteCache: overwriteCache,
        );
      }

      cacheController.addToCache(key: activityId, value: newActivity, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache activity: $activity - ex: $ex');
    }
  }
}

void cacheRelationshipData(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> relationships = (data.containsKey('relationships') ? data['relationships'] : []).map((dynamic relationship) => json.decodeSafe(relationship)).toList();

  for (final dynamic relationship in relationships) {
    try {
      logger.d('requestNextTimelinePage() - parsing relationship: $relationship');
      final Relationship newRelationship = Relationship.fromJson(relationship);
      final String relationshipId = newRelationship.flMeta?.id ?? '';
      if (relationshipId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship');
        continue;
      }

      cacheController.addToCache(key: relationshipId, value: newRelationship, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship - ex: $ex');
    }
  }
}

void cacheTagData(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> tags = (data.containsKey('tags') ? data['tags'] : []).map((dynamic tag) => json.decodeSafe(tag)).toList();

  for (final dynamic tag in tags) {
    try {
      logger.d('requestNextTimelinePage() - parsing tag: $tag');
      final Tag newTag = Tag.fromJson(tag);

      if (newTag.key.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache tag: $tag');
        continue;
      }

      cacheController.addToCache(key: newTag.key, value: newTag, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache tag: $tag - ex: $ex');
    }
  }
}

void cacheGuidanceDirectoryEntries(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> entries = (data.containsKey('guidanceDirectoryEntries') ? data['guidanceDirectoryEntries'] : []).map((dynamic entry) => json.decodeSafe(entry)).toList();

  for (final dynamic entry in entries) {
    try {
      logger.d('requestNextTimelinePage() - parsing entry: $entry');
      final GuidanceDirectoryEntry newEntry = GuidanceDirectoryEntry.fromJson(entry);
      final String entryId = newEntry.flMeta?.id ?? '';
      if (entryId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache entry: $entry');
        continue;
      }

      cacheController.addToCache(key: entryId, value: newEntry, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache entry: $entry - ex: $ex');
    }
  }
}

void cacheReactionStatisticsData({
  required String feed,
  required Map<String, int> reactionCounts,
  String activityId = '',
  String reactionId = '',
  String userId = '',
  bool overwriteCache = true,
}) {
  final Logger logger = providerContainer.read(loggerProvider);
  final ReactionStatistics newReactionStatistics = ReactionStatistics(
    feed: feed,
    counts: reactionCounts,
    activityId: activityId,
    reactionId: reactionId,
    userId: userId,
  );

  final String cacheKey = ReactionStatistics.buildCacheKey(newReactionStatistics);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
  cacheController.addToCache(key: cacheKey, value: newReactionStatistics, overwrite: overwriteCache);
  logger.i('cacheReactionStatisticsData() - Cached reaction statistics: $newReactionStatistics');
}
