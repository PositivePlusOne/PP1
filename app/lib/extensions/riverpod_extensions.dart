// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import '../dtos/database/activities/tags.dart';
import '../dtos/database/relationships/relationship.dart';

extension ProviderContainerExt on ProviderContainer {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
    cacheRelationshipData(data);
    cacheTagData(data);
    cacheGuidanceDirectoryEntries(data);
  }
}

extension AutoDisposeFutureProviderRefExt on AutoDisposeFutureProviderRef {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
    cacheRelationshipData(data);
    cacheTagData(data);
    cacheGuidanceDirectoryEntries(data);
  }
}

extension NotifierProviderRefExt on NotifierProviderRef {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
    cacheRelationshipData(data);
    cacheTagData(data);
    cacheGuidanceDirectoryEntries(data);
  }
}

extension WidgetRefExt on WidgetRef {
  void cacheResponseData(Map<String, dynamic> data) {
    cacheProfileData(data);
    cacheActivityData(data);
    cacheRelationshipData(data);
    cacheTagData(data);
    cacheGuidanceDirectoryEntries(data);
  }
}

void cacheProfileData(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> profiles = (data.containsKey('users') ? data['users'] : []).map((dynamic profile) => json.decodeSafe(profile)).toList();
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

      newActivities.add(newActivity);
      cacheController.addToCache(activityId, newActivity);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache activity: $activity - ex: $ex');
    }
  }

  logger.d('requestNextTimelinePage() - newActivities: $newActivities');
}

void cacheRelationshipData(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> relationships = (data.containsKey('relationships') ? data['relationships'] : []).map((dynamic relationship) => json.decodeSafe(relationship)).toList();
  final List<Relationship> newRelationships = [];

  for (final dynamic relationship in relationships) {
    try {
      logger.d('requestNextTimelinePage() - parsing relationship: $relationship');
      final Relationship newRelationship = Relationship.fromJson(relationship);
      final String relationshipId = newRelationship.flMeta?.id ?? '';
      if (relationshipId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship');
        continue;
      }

      newRelationships.add(newRelationship);
      cacheController.addToCache(relationshipId, newRelationship);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship - ex: $ex');
    }
  }
}

void cacheTagData(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> tags = (data.containsKey('tags') ? data['tags'] : []).map((dynamic tag) => json.decodeSafe(tag)).toList();
  final List<Tag> newTags = [];

  for (final dynamic tag in tags) {
    try {
      logger.d('requestNextTimelinePage() - parsing tag: $tag');
      final Tag newTag = Tag.fromJson(tag);
      final String tagId = newTag.flMeta?.id ?? '';
      if (tagId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache tag: $tag');
        continue;
      }

      newTags.add(newTag);
      cacheController.addToCache(tagId, newTag);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache tag: $tag - ex: $ex');
    }
  }
}

void cacheGuidanceDirectoryEntries(Map<String, dynamic> data) {
  final Logger logger = providerContainer.read(loggerProvider);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

  final List<dynamic> entries = (data.containsKey('guidanceDirectoryEntries') ? data['guidanceDirectoryEntries'] : []).map((dynamic entry) => json.decodeSafe(entry)).toList();
  final List<GuidanceDirectoryEntry> newEntries = [];

  for (final dynamic entry in entries) {
    try {
      logger.d('requestNextTimelinePage() - parsing entry: $entry');
      final GuidanceDirectoryEntry newEntry = GuidanceDirectoryEntry.fromJson(entry);
      final String entryId = newEntry.flMeta?.id ?? '';
      if (entryId.isEmpty) {
        logger.e('requestNextTimelinePage() - Failed to cache entry: $entry');
        continue;
      }

      newEntries.add(newEntry);
      cacheController.addToCache(entryId, newEntry);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - Failed to cache entry: $entry - ex: $ex');
    }
  }
}
