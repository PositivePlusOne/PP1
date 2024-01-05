// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';

Iterable<String> buildExpectedCacheKeysFromObjects(Profile? currentProfile, Iterable<dynamic> objs) {
  final List<String> cacheKeys = [];

  //* Dart 3?
  for (final dynamic obj in objs) {
    if (obj == null) {
      continue;
    }

    if (obj is Iterable) {
      cacheKeys.addAll(buildExpectedCacheKeysFromObjects(currentProfile, obj));
      continue;
    }

    if (obj is Activity) {
      cacheKeys.addAll(buildExpectedCacheKeysForActivity(currentProfile, obj));
      continue;
    } else if (obj is Profile) {
      cacheKeys.addAll(buildExpectedCacheKeysForProfile(currentProfile, obj));
      continue;
    } else if (obj is Reaction) {
      cacheKeys.addAll(buildExpectedCacheKeysForReaction(currentProfile, obj));
      continue;
    } else if (obj is ReactionStatistics) {
      cacheKeys.addAll(buildExpectedCacheKeysForReactionStatistics(currentProfile, obj));
      continue;
    } else if (obj is ProfileStatistics) {
      cacheKeys.addAll(buildExpectedCacheKeysForProfileStatistics(currentProfile, obj));
      continue;
    } else if (obj is Relationship) {
      cacheKeys.addAll(buildExpectedCacheKeysForRelationship(currentProfile, obj));
      continue;
    } else if (obj is TargetFeed) {
      cacheKeys.addAll(buildExpectedCacheKeysForTargetFeed(currentProfile, obj));
      continue;
    } else if (obj is String) {
      cacheKeys.add(obj);
      continue;
    }
  }

  // Add current profile key
  if (currentProfile?.flMeta?.id?.isNotEmpty ?? false) {
    cacheKeys.add(currentProfile!.flMeta!.id!);
  }

  // Remove empty values
  cacheKeys.removeWhere((element) => element.isEmpty);

  // Remove duplicates
  return cacheKeys.toSet();
}

List<String> buildExpectedCacheKeysForRelationship(Profile? currentProfile, Relationship relationship) {
  final List<String> cacheKeys = [];

  final String relationshipId = relationship.flMeta?.id ?? '';
  cacheKeys.add(relationshipId);

  for (final RelationshipMember member in relationship.members) {
    if (member.memberId.isNotEmpty) {
      cacheKeys.add(member.memberId);
    }
  }

  return cacheKeys;
}

List<String> buildExpectedCacheKeysForReaction(Profile? currentProfile, Reaction reaction) {
  final List<String> cacheKeys = [];

  final String reactionId = reaction.flMeta?.id ?? '';
  final String activityId = reaction.activityId;
  final String reactorId = reaction.userId;

  if (reactionId.isNotEmpty) {
    cacheKeys.add(reactionId);
  }

  if (activityId.isNotEmpty) {
    cacheKeys.add(activityId);
  }

  if (reactorId.isNotEmpty) {
    cacheKeys.add(reactorId);
  }

  return cacheKeys;
}

List<String> buildExpectedCacheKeysForReactionStatistics(Profile? currentProfile, ReactionStatistics statistics) {
  final List<String> cacheKeys = [];

  final String statisticsId = statistics.flMeta?.id ?? '';
  final String activityId = statistics.activityId;
  final String reactorId = statistics.userId;

  if (statisticsId.isNotEmpty) {
    cacheKeys.add(statisticsId);
  }

  if (activityId.isNotEmpty) {
    cacheKeys.add(activityId);
  }

  if (reactorId.isNotEmpty) {
    cacheKeys.add(reactorId);
  }

  return cacheKeys;
}

List<String> buildExpectedCacheKeysForProfileStatistics(Profile? currentProfile, ProfileStatistics statistics) {
  final List<String> cacheKeys = [];

  final String statisticsId = statistics.flMeta?.id ?? '';
  final String profileId = statistics.profileId;

  if (statisticsId.isNotEmpty) {
    cacheKeys.add(statisticsId);
  }

  if (profileId.isNotEmpty) {
    cacheKeys.add(profileId);
  }

  return cacheKeys;
}

List<String> buildExpectedCacheKeysForProfile(Profile? currentProfile, Profile targetProfile) {
  final List<String> cacheKeys = [];
  final String targetProfileId = targetProfile.flMeta?.id ?? '';
  final String currentProfileId = currentProfile?.flMeta?.id ?? '';

  // Generate the profiles key
  if (targetProfileId.isNotEmpty) {
    cacheKeys.add(targetProfileId);
  }

  // Generate a relationship key
  if (currentProfileId.isNotEmpty && targetProfileId.isNotEmpty) {
    final String relationshipKey = [currentProfileId, targetProfileId].asGUID;
    cacheKeys.add(relationshipKey);
  }

  return cacheKeys;
}

List<TargetFeed> buildTargetFeedsForActivity({
  required Activity activity,
  required Profile? currentProfile,
}) {
  final List<TargetFeed> targetFeeds = [];

  final List<TargetFeed> activityTargetFeeds = activity.getTargetFeeds(currentProfile: currentProfile);
  final List<TargetFeed> repostTargetFeeds = activity.getTargetFeeds(currentProfile: currentProfile);
  final List<TargetFeed> tagTargetFeeds = activity.tagTargetFeeds;

  // Add the activity target feed
  for (final TargetFeed activityTargetFeed in activityTargetFeeds) {
    if (activityTargetFeed.targetSlug.isNotEmpty && activityTargetFeed.targetUserId.isNotEmpty) {
      targetFeeds.add(activityTargetFeed);
    }
  }

  for (final TargetFeed repostTargetFeed in repostTargetFeeds) {
    if (repostTargetFeed.targetSlug.isNotEmpty && repostTargetFeed.targetUserId.isNotEmpty) {
      targetFeeds.add(repostTargetFeed);
    }
  }

  // Add the tag target feeds
  for (final TargetFeed tagTargetFeed in tagTargetFeeds) {
    if (tagTargetFeed.targetSlug.isNotEmpty && tagTargetFeed.targetUserId.isNotEmpty) {
      targetFeeds.add(tagTargetFeed);
    }
  }

  return targetFeeds;
}

List<String> buildExpectedCacheKeysForActivity(Profile? currentProfile, Activity activity) {
  final List<String> cacheKeys = [];

  final String activityId = activity.flMeta?.id ?? '';
  final String currentProfileId = currentProfile?.flMeta?.id ?? '';
  final String activityPublisherId = activity.publisherInformation?.publisherId ?? '';

  final String repostedActivityId = activity.repostConfiguration?.targetActivityId ?? '';
  final String repostedPublisherId = activity.repostConfiguration?.targetActivityPublisherId ?? '';

  final List<TargetFeed> targetFeeds = buildTargetFeedsForActivity(activity: activity, currentProfile: currentProfile);

  // Generate the activity key
  if (activityId.isNotEmpty) {
    cacheKeys.add(activityId);
  }

  // Generate the publisher key
  if (activityPublisherId.isNotEmpty) {
    cacheKeys.add(activityPublisherId);
  }

  // Generate the reposted activity key
  if (repostedActivityId.isNotEmpty) {
    cacheKeys.add(repostedActivityId);
  }

  // Generate the reposted publisher key
  if (repostedPublisherId.isNotEmpty) {
    cacheKeys.add(repostedPublisherId);
  }

  // Generate the tag target feed keys
  for (final TargetFeed targetFeed in targetFeeds) {
    cacheKeys.addAll(buildExpectedCacheKeysForTargetFeed(currentProfile, targetFeed));

    final String origin = TargetFeed.toOrigin(targetFeed);
    final String reactionStateKey = PositiveReactionsState.buildReactionsCacheKey(activityId: activityId, profileId: currentProfileId, activityOrigin: origin);
    cacheKeys.add(reactionStateKey);
  }

  // Generate a relationship key for the publisher
  if (currentProfileId.isNotEmpty && activityPublisherId.isNotEmpty) {
    final String relationshipKey = [currentProfileId, activityPublisherId].asGUID;
    cacheKeys.add(relationshipKey);
  }

  // Generate a relationship key for the reposted publisher
  if (currentProfileId.isNotEmpty && repostedPublisherId.isNotEmpty) {
    final String relationshipKey = [currentProfileId, repostedPublisherId].asGUID;
    cacheKeys.add(relationshipKey);
  }

  // Add promotion keys
  final String promotionKey = activity.enrichmentConfiguration?.promotionKey ?? '';
  if (promotionKey.isNotEmpty) {
    cacheKeys.add(promotionKey);
  }

  return cacheKeys;
}

List<String> buildExpectedCacheKeysForTargetFeed(Profile? currentProfile, TargetFeed targetFeed) {
  final List<String> cacheKeys = [];

  final String targetKey = PositiveFeedState.buildFeedCacheKey(targetFeed);
  if (targetKey.isNotEmpty) {
    cacheKeys.add(targetKey);
  }

  return cacheKeys;
}
