// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/content/sharing_controller.dart';
import 'package:app/providers/enrichment/activity_enrichment_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
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

  bool get isPromotion => enrichmentConfiguration?.promotionKey.isNotEmpty == true && enrichmentConfiguration?.tags.contains('promotion') == true;
  bool get isChatPromotion => isPromotion && enrichmentConfiguration?.tags.contains('promotion_chat') == true;
  bool get isFeedPromotion => isPromotion && enrichmentConfiguration?.tags.contains('promotion_feed') == true;

  String get shortDescription {
    return generalConfiguration?.content.isNotEmpty == true ? generalConfiguration!.content : '';
  }

  TargetFeed get primaryFeed {
    if (repostConfiguration?.targetActivityOriginFeed.isNotEmpty == true) {
      return TargetFeed.fromOrigin(repostConfiguration!.targetActivityOriginFeed);
    }

    return TargetFeed.fromOrigin(publisherInformation?.originFeed ?? '');
  }

  List<TargetFeed> getTargetFeeds({
    required Profile? currentProfile,
  }) {
    final List<TargetFeed> targetFeeds = <TargetFeed>[];
    final TargetFeed feed = TargetFeed.fromOrigin(publisherInformation?.originFeed ?? '');
    targetFeeds.add(feed);

    // Check if we should include a timeline
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (currentProfileId.isNotEmpty) {
      final TargetFeed timelineFeed = TargetFeed(targetSlug: 'timeline', targetUserId: currentProfileId);
      targetFeeds.add(timelineFeed);
    }

    return targetFeeds;
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

  void appendActivityToProfileFeeds(String currentProfileId) {
    final TargetFeed userFeed = TargetFeed(targetSlug: 'user', targetUserId: currentProfileId);
    final TargetFeed timelineFeed = TargetFeed(targetSlug: 'timeline', targetUserId: currentProfileId);

    final String expectedUserFeedCacheKey = PositiveFeedState.buildFeedCacheKey(userFeed);
    final String expectedTimelineFeedCacheKey = PositiveFeedState.buildFeedCacheKey(timelineFeed);

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final PositiveFeedState? userFeedState = cacheController.get(expectedUserFeedCacheKey);
    final PositiveFeedState? timelineFeedState = cacheController.get(expectedTimelineFeedCacheKey);

    if (userFeedState != null) {
      final PagingController<String, Activity> pagingController = userFeedState.pagingController;
      final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

      final bool exists = currentItems.any((Activity activity) => activity.flMeta?.id == flMeta?.id);
      if (exists) {
        final int index = currentItems.indexWhere((Activity activity) => activity.flMeta?.id == flMeta?.id);
        currentItems[index] = this;
      } else {
        currentItems.insert(0, this);
      }

      pagingController.itemList = currentItems;

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      pagingController.notifyListeners();

      cacheController.add(key: expectedUserFeedCacheKey, value: userFeedState);
    }

    if (timelineFeedState != null) {
      final PagingController<String, Activity> pagingController = timelineFeedState.pagingController;
      final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

      final bool exists = currentItems.any((Activity activity) => activity.flMeta?.id == flMeta?.id);
      if (exists) {
        final int index = currentItems.indexWhere((Activity activity) => activity.flMeta?.id == flMeta?.id);
        currentItems[index] = this;
      } else {
        currentItems.insert(0, this);
      }

      pagingController.itemList = currentItems;

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      pagingController.notifyListeners();

      cacheController.add(key: expectedTimelineFeedCacheKey, value: timelineFeedState);
    }

    for (final String tag in enrichmentConfiguration?.tags ?? <String>[]) {
      final TargetFeed tagFeed = TargetFeed.fromTag(tag);
      final String expectedTagFeedCacheKey = PositiveFeedState.buildFeedCacheKey(tagFeed);

      final PositiveFeedState? tagFeedState = cacheController.get(expectedTagFeedCacheKey);
      if (tagFeedState != null) {
        final PagingController<String, Activity> pagingController = tagFeedState.pagingController;
        final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

        final bool exists = currentItems.any((Activity activity) => activity.flMeta?.id == flMeta?.id);
        if (exists) {
          final int index = currentItems.indexWhere((Activity activity) => activity.flMeta?.id == flMeta?.id);
          currentItems[index] = this;
        } else {
          currentItems.insert(0, this);
        }

        pagingController.itemList = currentItems;

        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        pagingController.notifyListeners();

        cacheController.add(key: expectedTagFeedCacheKey, value: tagFeedState);
      }
    }
  }

  Future<void> share(BuildContext context, Profile? currentProfile) async {
    final SharingController sharingController = providerContainer.read(sharingControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);

    if (publisherInformation?.originFeed.isEmpty ?? true == true) {
      logger.e('publisherInformation.originFeed is empty');
      throw Exception('publisherInformation.originFeed is empty');
    }

    // typedef SharePostOptions = (Activity activity, String origin, String currentProfileId);
    final String originFeed = publisherInformation?.originFeed ?? '';
    final SharePostOptions postOptions = (
      activity: this,
      origin: originFeed,
      currentProfile: currentProfile,
      currentUser: firebaseAuth.currentUser,
    );

    await sharingController.showShareDialog(context, ShareTarget.post, postOptions: postOptions);
  }

  //* Verifies whether the activity can be included in the paged data.
  //* Not the same as whether the post should be hidden due to blocked state
  bool canDisplayOnFeed(Profile? currentProfile, Relationship? relationshipWithActivityPublisher) {
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final Set<RelationshipState> states = relationshipWithActivityPublisher?.relationshipStatesForEntity(currentProfileId) ?? <RelationshipState>{};
    final bool hasFullyConnected = states.contains(RelationshipState.sourceConnected) && states.contains(RelationshipState.targetConnected);
    final bool isFollowing = states.contains(RelationshipState.sourceFollowed);

    final String publisherId = publisherInformation?.publisherId ?? '';
    if (currentProfileId == publisherId) {
      return true;
    }

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
    required ReactionType kind,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    ReactionStatistics statistics = ReactionStatistics(
      activityId: flMeta?.id ?? '',
      counts: {},
    );

    final String activityId = flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String expectedCacheKey = PositiveReactionsState.buildReactionsCacheKey(
      activityId: activityId,
      profileId: currentProfileId,
    );

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
    required Profile? targetProfile,
    required Profile? currentProfile,
  }) async {
    final String targetProfileId = targetProfile?.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    if (currentProfileId.isNotEmpty && currentProfileId == targetProfileId) {
      await PositiveDialog.show(
        title: '',
        context: context,
        barrierDismissible: true,
        child: PostOptionsDialog(
          onEditPostSelected: () => onPostEdited(popRoute: true),
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
    required Profile? currentProfile,
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
    required Profile? currentProfile,
  }) async {
    final ActivitiesController activityController = providerContainer.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    try {
      await activityController.deleteActivity(activity: this, currentProfile: currentProfile);
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

    // Check if we are on the Post Page
    if (router.current.name == PostRoute.name) {
      await router.pop();
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

  Reaction? getUniqueReaction({
    required Profile? currentProfile,
    required ReactionType kind,
  }) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final List<String> cacheKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: this, currentProfile: currentProfile);
    final List<Reaction> reactions = cacheController.list(cacheKeys).whereType<Reaction>().toList();
    return reactions.firstWhereOrNull((element) => element.kind == kind);
  }

  void incrementReactionCount({
    required ReactionStatistics cachedState,
    required ReactionType kind,
    required int offset,
  }) {
    final String activityId = flMeta?.id ?? '';
    if (activityId.isEmpty) {
      return;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final String feedStateKey = reactionsController.buildExpectedStatisticsCacheKey(
      activityId: activityId,
    );

    final Map<String, int> counts = {...cachedState.counts};
    final String kindStr = ReactionType.toJson(kind);
    counts[kindStr] = (counts[kindStr] ?? 0) + offset;

    final ReactionStatistics newState = cachedState.copyWith(counts: counts);
    cacheController.add(key: feedStateKey, value: newState);
  }

  PositiveReactionsState? getReactionsFeedState({
    required Profile? currentProfile,
  }) {
    final String activityId = flMeta?.id ?? '';
    if (activityId.isEmpty) {
      return null;
    }

    final String activityFeedStateCacheKey = PositiveReactionsState.buildReactionsCacheKey(
      activityId: activityId,
      profileId: currentProfile?.flMeta?.id ?? '',
    );

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final PositiveReactionsState? activityReactionFeedState = cacheController.get(activityFeedStateCacheKey);

    return activityReactionFeedState;
  }

  Future<void> onPostBookmarked({
    required BuildContext context,
    required Profile? currentProfile,
  }) async {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);

    final PositiveReactionsState? reactionsFeedState = getReactionsFeedState(currentProfile: currentProfile);

    final String activityId = flMeta?.id ?? '';
    final String profileId = currentProfile?.flMeta?.id ?? '';

    if (profileId.isEmpty || activityId.isEmpty) {
      throw Exception('Invalid activity or user');
    }

    final bool isBookmarked = isActivityBookmarked(currentProfile: currentProfile);
    if (isBookmarked) {
      await reactionsController.removeBookmarkActivity(activity: this, currentProfile: currentProfile, reactionsFeedState: reactionsFeedState);
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post unbookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
      );
      return;
    }

    await reactionsController.bookmarkActivity(activityId: activityId);
    ScaffoldMessenger.of(context).showSnackBar(
      PositiveGenericSnackBar(title: 'Post bookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
    );
  }

  bool isActivityLiked({
    required Profile? currentProfile,
  }) =>
      hasUniqueReaction(currentProfile: currentProfile, kind: const ReactionType.like());

  bool isActivityBookmarked({
    required Profile? currentProfile,
  }) =>
      hasUniqueReaction(currentProfile: currentProfile, kind: const ReactionType.bookmark());

  bool hasUniqueReaction({
    required Profile? currentProfile,
    required ReactionType kind,
  }) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final List<String> cacheKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: this, currentProfile: currentProfile);
    return cacheController.list(cacheKeys).any((element) => element is Reaction && element.kind == kind);
  }

  Future<void> onPostLiked({
    required BuildContext context,
    required Profile? currentProfile,
    required Activity? activity,
  }) async {
    if (activity == null) {
      throw Exception('reactionsFeedState is null');
    }

    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);

    final String profileId = currentProfile?.flMeta?.id ?? '';
    final String activityId = flMeta?.id ?? '';

    if (profileId.isEmpty || activityId.isEmpty) {
      throw Exception('Invalid activity or user');
    }
    ReactionStatistics reactionStatistics = reactionsController.getStatisticsForActivity(activityId: activityId);
    final bool isLiked = isActivityLiked(currentProfile: currentProfile);

    if (isLiked) {
      logger.d('unliking post');
      await reactionsController.unlikeActivity(activity: this, currentProfile: currentProfile);
      // update the count to be one fewer
      incrementReactionCount(cachedState: reactionStatistics, kind: const ReactionType.like(), offset: -1);
      // and show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post unliked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
      );
    } else {
      logger.d('liking post');
      await reactionsController.likeActivity(activityId: activityId);
      // update the count to be one more
      incrementReactionCount(cachedState: reactionStatistics, kind: const ReactionType.like(), offset: 1);
      // and show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post liked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
      );
    }
  }

  Future<void> onRequestPostSharedToFeed({
    required String repostActivityId,
  }) async {
    if (repostActivityId.isEmpty) {
      throw Exception('Invalid activity ID for repost');
    }

    final AppRouter router = providerContainer.read(appRouterProvider);
    await router.push(
      CreatePostRoute(
        activityData: ActivityData(
          reposterActivityID: repostActivityId,
          postType: PostType.repost,
        ),
        isEditPage: false,
      ),
    );
  }

  Future<void> onPostEdited({
    bool popRoute = false,
  }) async {
    final AppRouter router = providerContainer.read(appRouterProvider);
    if (generalConfiguration == null) {
      return;
    }

    if (popRoute) {
      await router.pop();
    }

    await router.push(
      CreatePostRoute(
        activityData: ActivityData(
          activityID: flMeta?.id,
          content: generalConfiguration?.content ?? '',
          tags: enrichmentConfiguration?.tags ?? const [],
          promotionKey: enrichmentConfiguration?.promotionKey ?? '',
          postType: PostType.getPostTypeFromActivity(this, true),
          media: media,
          reposterActivityID: '',
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

  Future<void> requestFullscreenMedia(Media media) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final MediaRoute mediaRoute = MediaRoute(
      media: media,
    );

    logger.i('Navigating to media ${media.name}');
    await router.push(mediaRoute);
  }

  Future<void> requestPostRoute({
    required BuildContext context,
    required Profile? currentProfile,
    String promotionId = '',
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final String profileId = currentProfile?.flMeta?.id ?? '';

    final ActivityEnrichmentController activityEnrichmentController = providerContainer.read(activityEnrichmentControllerProvider(profileId).notifier);
    activityEnrichmentController.registerActivityAction(const ActivityEnrichmentTagAction.openPost(), this);

    final String activityId = flMeta?.id ?? '';
    final PostRoute postRoute = PostRoute(
      activityId: activityId,
      promotionId: promotionId,
      feed: primaryFeed,
    );

    // Check if we are already on the post page.
    if (router.current.name == PostRoute.name) {
      logger.i('Already on post $activityId');
      return;
    }

    logger.d('Tracking post view for $activityId');
    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(
      AnalyticEvents.postViewed,
      includeDefaultProperties: true,
      properties: {
        'activityId': activityId,
        'feed': primaryFeed.targetSlug,
        'profileId': profileId,
        'promotionId': promotionId,
      },
    );

    logger.i('Navigating to post $activityId');
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
    required Activity? activity,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String publisherProfileId = activity?.publisherInformation?.publisherId ?? '';

    if (currentProfileId == publisherProfileId) {
      return true;
    }

    if (publisherProfileId.isEmpty) {
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.disabled()) {
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.private() && currentProfileId == publisherProfileId) {
      return true;
    }

    if (this == const ActivitySecurityConfigurationMode.private()) {
      return false;
    }

    if (this == const ActivitySecurityConfigurationMode.public() || (this == const ActivitySecurityConfigurationMode.signedIn() && currentProfileId.isNotEmpty)) {
      return true;
    }

    if (publisherRelationship == null) {
      logger.e('canActOnSecurityMode() - relationship is null');
      return false;
    }

    final Set<RelationshipState> relationshipStates = publisherRelationship.relationshipStatesForEntity(currentProfileId);
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
