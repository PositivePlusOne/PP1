// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
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
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
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
    final Relationship? relationship = cacheController.getFromCache(expectedGUID);

    if (relationship != null) {
      return relationship;
    }

    return Relationship.empty(<String>[publisherId, currentUserId]);
  }
}
