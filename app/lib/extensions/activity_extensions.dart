// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/sharing_controller.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import '../dtos/database/activities/activities.dart';
import '../dtos/database/common/media.dart';

extension ActivityExt on Activity {
  bool get hasContentToDisplay {
    final bool hasPublisher = publisherInformation?.publisherId.isNotEmpty == true;
    final bool hasBodyContent = generalConfiguration?.content.isNotEmpty == true;
    final bool hasImageMedia = media.where((Media media) => media.type == MediaType.photo_link || media.type == MediaType.video_link).isNotEmpty;
    return hasPublisher && (hasBodyContent || hasImageMedia);
  }

  String get shortDescription {
    return generalConfiguration?.content.isNotEmpty == true ? generalConfiguration!.content : '';
  }

  List<TargetFeed> get tagTargetFeeds {
    final List<TargetFeed> targetFeeds = <TargetFeed>[];
    if (enrichmentConfiguration?.tags != null) {
      for (final String tag in enrichmentConfiguration!.tags) {
        targetFeeds.add(TargetFeed('tags', tag));
      }
    }

    return targetFeeds;
  }

  Future<void> share(BuildContext context) async {
    final SharingController sharingController = providerContainer.read(sharingControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);
    if (publisherInformation?.originFeed.isEmpty ?? true == true) {
      logger.e('publisherInformation.originFeed is empty');
      throw Exception('publisherInformation.originFeed is empty');
    }

    final (Activity activity, String feed) postOptions = (this, publisherInformation!.originFeed);
    await sharingController.showShareDialog(context, ShareTarget.post, postOptions: postOptions);
  }

  bool get canDisplayOnFeed {
    final Relationship relationship = getRelationship();
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    final Set<RelationshipState> states = relationship.relationshipStatesForEntity(profileController.currentProfileId ?? '');
    final bool hasFullyConnected = states.contains(RelationshipState.sourceConnected) && states.contains(RelationshipState.targetConnected);
    final bool isFollowing = states.contains(RelationshipState.sourceFollowed);

    // Check if we have hidden the posts, or if the publisher has blocked us
    if (states.contains(RelationshipState.sourceHidden) || states.contains(RelationshipState.targetBlocked)) {
      return false;
    }

    // This logic needs to take into account the current user's relationship with the publisher and the security modes of the activities
    final ActivitySecurityConfigurationMode viewMode = securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();

    return viewMode.when(
      public: () => true,
      followersAndConnections: () => isFollowing || hasFullyConnected,
      connections: () => hasFullyConnected,
      signedIn: () => profileController.currentProfileId != null,
      private: () => false,
      disabled: () => false,
    );
  }

  Relationship getRelationship() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    final String publisherId = publisherInformation?.publisherId ?? '';
    final String currentUserId = profileController.currentProfileId ?? '';

    if (publisherId.isEmpty || currentUserId.isEmpty) {
      return Relationship.empty(<String>[]);
    }

    if (publisherId == currentUserId) {
      return Relationship.owner(<String>[currentUserId]);
    }

    final String expectedGUID = <String>[publisherId, currentUserId].asGUID;
    final Relationship? relationship = cacheController.get(expectedGUID);

    if (relationship != null) {
      return relationship;
    }

    return Relationship.empty(<String>[publisherId, currentUserId]);
  }
}

extension ActivitySecurityConfigurationModeExtensions on ActivitySecurityConfigurationMode {
  bool get isPublic => this == const ActivitySecurityConfigurationMode.public();
  bool get isFollowersAndConnections => this == const ActivitySecurityConfigurationMode.followersAndConnections();
  bool get isConnections => this == const ActivitySecurityConfigurationMode.connections();
  bool get isSignedIn => this == const ActivitySecurityConfigurationMode.signedIn();
  bool get isPrivate => this == const ActivitySecurityConfigurationMode.private();
  bool get isDisabled => this == const ActivitySecurityConfigurationMode.disabled();

  bool canActOnActivity(
    String activityId, {
    String currentProfileId = '',
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    if (activityId.isEmpty) {
      logger.e('canActOnSecurityMode() - activityId is empty');
      return false;
    }

    if (currentProfileId.isEmpty) {
      final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
      currentProfileId = profileController.currentProfileId ?? '';
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Activity? activity = cacheController.get<Activity>(activityId);
    final String publisherProfileId = activity?.publisherInformation?.publisherId ?? '';

    if (activity == null || publisherProfileId.isEmpty) {
      logger.e('canActOnSecurityMode() - currentProfileId or publisherProfileId is empty');
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.disabled()) {
      logger.d('canActOnSecurityMode() - mode is disabled');
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.private() && currentProfileId == publisherProfileId) {
      logger.d('canActOnSecurityMode() - mode is private and currentProfileId is not the publisherProfileId');
      return true;
    }

    if (this == const ActivitySecurityConfigurationMode.private()) {
      logger.d('canActOnSecurityMode() - mode is private and currentProfileId is not the publisherProfileId');
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.public() || (this == const ActivitySecurityConfigurationMode.signedIn() && currentProfileId.isNotEmpty)) {
      logger.d('canActOnSecurityMode() - mode is public or signedIn and currentProfileId is not empty');
      return true;
    }

    final String relationshipId = [currentProfileId, publisherProfileId].asGUID;
    final Relationship? relationship = cacheController.get<Relationship>(relationshipId);

    if (relationship == null) {
      logger.e('canActOnSecurityMode() - relationship is null');
      return false;
    }

    final Set<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentProfileId);
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    final bool isFollowing = relationshipStates.contains(RelationshipState.sourceFollowed);

    if (this == const ActivitySecurityConfigurationMode.connections()) {
      return isConnected;
    }

    if (this == const ActivitySecurityConfigurationMode.followersAndConnections()) {
      return isConnected || isFollowing;
    }

    return true;
  }
}
