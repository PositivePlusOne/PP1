// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/content/sharing_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
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

  TargetFeed get targetFeed {
    return TargetFeed.fromOrigin(publisherInformation?.originFeed ?? '');
  }

  TargetFeed get repostTargetFeed {
    return TargetFeed.fromOrigin(repostConfiguration?.targetActivityOriginFeed ?? '');
  }

  List<TargetFeed> get tagTargetFeeds {
    final List<TargetFeed> targetFeeds = <TargetFeed>[];
    if (enrichmentConfiguration?.tags != null) {
      for (final String tag in enrichmentConfiguration!.tags) {
        targetFeeds.add(TargetFeed.tag(tag));
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

  //* Verifies whether the activity can be included in the paged data.
  //* Not the same as whether the post should be hidden due to blocked state
  bool canDisplayOnFeed(String currentProfileId, Relationship relationship) {
    final Set<RelationshipState> states = relationship.relationshipStatesForEntity(currentProfileId);
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
      signedIn: () => currentProfileId.isNotEmpty,
      private: () => false,
      disabled: () => false,
    );
  }

  ReactionStatistics getStatistics({
    required Profile? currentProfile,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    ReactionStatistics statistics = ReactionStatistics(
      activityId: flMeta?.id ?? '',
      counts: {},
    );

    final String activityId = flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String expectedCacheKey = PositiveReactionsState.buildReactionsCacheKey(activityId, currentProfileId);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ReactionStatistics? cachedStatistics = cacheController.get(expectedCacheKey);
    if (cachedStatistics != null) {
      logger.i('getStatisticsForActivity: $activityId, found in cache');
      return cachedStatistics;
    }

    logger.i('getStatisticsForActivity: $activityId, not found in cache');
    cacheController.add(key: expectedCacheKey, value: statistics, metadata: statistics.flMeta);

    return statistics;
  }

  Relationship getPublisherRelationship(Profile currentProfile) {
    final String publisherId = publisherInformation?.publisherId ?? '';
    final String currentProfileId = currentProfile.flMeta?.id ?? '';

    if (publisherId.isEmpty || currentProfileId.isEmpty) {
      return Relationship.empty(<String>[]);
    }

    if (publisherId == currentProfileId) {
      return Relationship.owner(<String>[currentProfileId]);
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String expectedGUID = <String>[publisherId, currentProfileId].asGUID;
    return cacheController.get(expectedGUID) ?? Relationship.empty(<String>[publisherId, currentProfileId]);
  }

  Relationship getReposterRelationship(Profile currentProfile) {
    final String reposterId = repostConfiguration?.targetActivityPublisherId ?? '';
    final String currentProfileId = currentProfile.flMeta?.id ?? '';

    if (reposterId.isEmpty || currentProfileId.isEmpty) {
      return Relationship.empty(<String>[]);
    }

    if (reposterId == currentProfileId) {
      return Relationship.owner(<String>[currentProfileId]);
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String expectedGUID = <String>[reposterId, currentProfileId].asGUID;
    return cacheController.get(expectedGUID) ?? Relationship.empty(<String>[reposterId, currentProfileId]);
  }

  Future<void> onPostOptionsSelected({
    required BuildContext context,
    required Profile targetProfile,
    required Profile currentProfile,
  }) async {
    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String currentProfileId = currentProfile.flMeta?.id ?? '';

    if (currentProfileId.isNotEmpty && currentProfileId == targetProfileId) {
      await PositiveDialog.show(
        title: '',
        context: context,
        barrierDismissible: true,
        child: PostOptionsDialog(
          onEditPostSelected: () => onPostEdited(context: context, currentProfile: currentProfile),
          onDeletePostSelected: () => onPostDeleted(context: context, currentProfile: currentProfile),
        ),
      );

      return;
    }

    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      child: ProfileModalDialog(
        targetProfileId: targetProfileId,
        currentProfileId: currentProfileId,
        activityId: flMeta?.id ?? '',
        types: const {
          ProfileModalDialogOptionType.viewProfile,
          ProfileModalDialogOptionType.follow,
          ProfileModalDialogOptionType.connect,
          ProfileModalDialogOptionType.message,
          ProfileModalDialogOptionType.block,
          ProfileModalDialogOptionType.report,
          ProfileModalDialogOptionType.hidePosts,
          ProfileModalDialogOptionType.reportPost,
        },
      ),
    );
  }

  Future<void> onPostDeleted({
    required BuildContext context,
    required Profile currentProfile,
  }) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.post_dialogue_delete_post,
      context: context,
      barrierDismissible: true,
      child: PostDeleteConfirmDialog(
        onDeletePostConfirmed: () => onPostDeleteConfirmed(
          context: context,
          currentProfile: currentProfile,
        ),
      ),
    );
  }

  Future<void> onPostDeleteConfirmed({
    required BuildContext context,
    required Profile currentProfile,
  }) async {
    final ActivitiesController activityController = providerContainer.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    try {
      await activityController.deleteActivity(this);
    } catch (e) {
      logger.e("Error deleting activity: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: localisations.post_dialogue_delete_post_fail,
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

      if (router.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
      }

      await router.pop();
      return;
    }

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: localisations.post_dialogue_delete_post_success,
      icon: UniconsLine.file_times_alt,
      backgroundColour: colours.black,
    );

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    await router.pop();
  }

  Future<void> onPostBookmarked({
    required BuildContext context,
    required Profile? currentProfile,
  }) async {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);

    final String activityId = flMeta?.id ?? '';
    final String origin = publisherInformation?.originFeed ?? '';
    final String profileId = currentProfile?.flMeta?.id ?? '';

    if (profileId.isEmpty || activityId.isEmpty || origin.isEmpty) {
      throw Exception('Invalid activity or user');
    }

    final bool isBookmarked = reactionsController.isActivityBookmarked(activityId, origin);
    if (isBookmarked) {
      await reactionsController.removeBookmarkActivity(origin: origin, activityId: activityId, uid: profileId);
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post unbookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
      );
      return;
    }

    await reactionsController.bookmarkActivity(origin: origin, activityId: activityId);
    ScaffoldMessenger.of(context).showSnackBar(
      PositiveGenericSnackBar(title: 'Post bookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
    );
  }

  Future<void> onPostLiked({
    required BuildContext context,
    required Profile? currentProfile,
    required PositiveReactionsState positiveReactionsState,
  }) async {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);

    final String profileId = currentProfile?.flMeta?.id ?? '';
    final String activityId = flMeta?.id ?? '';
    final String origin = publisherInformation?.originFeed ?? '';

    if (profileId.isEmpty || activityId.isEmpty || origin.isEmpty) {
      throw Exception('Invalid activity or user');
    }

    final bool isLiked = reactionsController.hasLikedActivity(currentProfile: currentProfile, positiveReactionsState: positiveReactionsState);
    if (isLiked) {
      await reactionsController.unlikeActivity(origin: origin, activityId: activityId, uid: profileId);
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post unliked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
      );
      return;
    }

    await reactionsController.likeActivity(origin: origin, activityId: activityId, uid: profileId);
    ScaffoldMessenger.of(context).showSnackBar(
      PositiveGenericSnackBar(title: 'Post liked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
    );
  }

  Future<void> onPostEdited({
    required BuildContext context,
    required Profile? currentProfile,
  }) async {
    final AppRouter router = providerContainer.read(appRouterProvider);

    if (generalConfiguration == null) {
      return;
    }

    await router.pop();
    await router.push(
      CreatePostRoute(
        activityData: ActivityData(
          activityID: flMeta?.id,
          content: generalConfiguration?.content ?? '',
          tags: enrichmentConfiguration?.tags ?? const [],
          postType: PostType.getPostTypeFromActivity(this),
          media: media,
          commentPermissionMode: securityConfiguration?.commentMode,
          visibilityMode: securityConfiguration?.viewMode,
          allowSharing: securityConfiguration?.shareMode == const ActivitySecurityConfigurationMode.public(),
          //! This is currently shared between ALL media!
          altText: media.any((element) => element.altText.isNotEmpty) ? media.firstWhere((element) => element.altText.isNotEmpty).altText : '',
        ),
        isEditPage: true,
      ),
    );
  }

  Future<void> requestPostRoute(BuildContext context) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final String activityId = flMeta?.id ?? '';

    final PostRoute postRoute = PostRoute(
      activityId: activityId,
      feed: targetFeed,
    );

    // Check if we are already on the post page.
    if (router.current.name == PostRoute.name) {
      logger.i('Already on post ${flMeta?.id}');
      return;
    }

    logger.i('Navigating to post ${flMeta?.id}');
    await router.push(postRoute);
  }

  Future<void> requestFullscreenMedia(Media media, TargetFeed? feed) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activityId: flMeta?.id ?? '',
      feed: feed ??
          TargetFeed(
            targetSlug: 'user',
            targetUserId: publisherInformation?.publisherId ?? '',
          ),
    );

    logger.i('Navigating to post ${flMeta?.id}');
    await router.push(postRoute);
  }
}

extension ActivitySecurityConfigurationModeExtensions on ActivitySecurityConfigurationMode {
  bool get isPublic => this == const ActivitySecurityConfigurationMode.public();
  bool get isFollowersAndConnections => this == const ActivitySecurityConfigurationMode.followersAndConnections();
  bool get isConnections => this == const ActivitySecurityConfigurationMode.connections();
  bool get isSignedIn => this == const ActivitySecurityConfigurationMode.signedIn();
  bool get isPrivate => this == const ActivitySecurityConfigurationMode.private();
  bool get isDisabled => this == const ActivitySecurityConfigurationMode.disabled();

  bool canActOnActivity({
    required Activity activity,
    required Profile? currentProfile,
    required Relationship? relationship,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String publisherProfileId = activity.publisherInformation?.publisherId ?? '';

    if (publisherProfileId.isEmpty) {
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
