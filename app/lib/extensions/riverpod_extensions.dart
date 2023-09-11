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
    cacheReactionData(data, overwriteCache["reactions"] ?? true);
    cacheReactionStatisticsData(data, overwriteCache["reactionStatistics"] ?? true);
    cacheActivityData(data, overwriteCache["activities"] ?? true);
    cacheRelationshipData(data, overwriteCache["relationships"] ?? true);
    cacheTagData(data, overwriteCache["tags"] ?? true);
    cacheGuidanceDirectoryEntries(data, overwriteCache["guidanceDirectoryEntries"] ?? true);
  }
}

extension AutoDisposeFutureProviderRefExt on AutoDisposeFutureProviderRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheReactionData(data, overwriteCache);
    cacheReactionStatisticsData(data, overwriteCache);
    cacheActivityData(data, overwriteCache);
    cacheRelationshipData(data, overwriteCache);
    cacheTagData(data, overwriteCache);
    cacheGuidanceDirectoryEntries(data, overwriteCache);
  }
}

extension NotifierProviderRefExt on NotifierProviderRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheReactionData(data, overwriteCache);
    cacheReactionStatisticsData(data, overwriteCache);
    cacheActivityData(data, overwriteCache);
    cacheRelationshipData(data, overwriteCache);
    cacheTagData(data, overwriteCache);
    cacheGuidanceDirectoryEntries(data, overwriteCache);
  }
}

extension WidgetRefExt on WidgetRef {
  void cacheResponseData(Map<String, dynamic> data, bool overwriteCache) {
    cacheProfileData(data, overwriteCache);
    cacheReactionData(data, overwriteCache);
    cacheReactionStatisticsData(data, overwriteCache);
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

      cacheController.addToCache(key: activityId, value: newActivity, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache activity: $activity - ex: $ex');
    }
  }
}

void cacheReactionData(Map<String, dynamic> data, bool overwriteCache) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> reactions = (data.containsKey('reactions') ? data['reactions'] : []).map((dynamic reaction) => json.decodeSafe(reaction)).toList();

  for (final dynamic reaction in reactions) {
    try {
      logger.d('requestNextTimelinePage() - parsing reaction: $reaction');
      final Reaction newReaction = Reaction.fromJson(reaction);
      final String reactionId = newReaction.flMeta?.id ?? '';
      if (reactionId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache reaction: $reaction');
        continue;
      }

      cacheController.addToCache(key: reactionId, value: newReaction, overwrite: overwriteCache);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache reaction: $reaction - ex: $ex');
    }
  }
}

void cacheReactionStatisticsData(Map<String, dynamic> data, bool overwriteCache) {
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> reactionStatisticsRaw = (data.containsKey('reactionStatistics') ? data['reactionStatistics'] : []).map((dynamic reactionStatistic) => json.decodeSafe(reactionStatistic)).toList();
  final List<ReactionStatistics> reactionStatistics = reactionStatisticsRaw.map((dynamic stat) => ReactionStatistics.fromJson(stat)).toList();

  for (ReactionStatistics reactionStatistic in reactionStatistics) {
    final String cacheKey = ReactionStatistics.buildCacheKey(reactionStatistic);
    cacheController.addToCache(key: cacheKey, value: reactionStatistic, overwrite: overwriteCache);
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
