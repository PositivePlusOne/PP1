// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/event_hook.dart';
import 'package:app/hooks/paging_controller_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/events/request_refresh_event.dart';
import 'package:app/providers/content/promotions_controller.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/behaviours/components/no_posts_placeholder.dart';
import 'package:app/widgets/behaviours/components/sliver_no_posts_placeholder.dart';
import 'package:app/widgets/behaviours/positive_cache_widget.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/organisms/home/events/notify_feed_seen_event.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends HookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.currentProfile,
    required this.feed,
    required this.feedState,
    this.shouldPersonalize = false,
    this.windowSize = 20,
    this.isSliver = true,
    this.onPageLoaded,
    this.emptyDataWidget,
    this.noPostsWidget,
    super.key,
  });

  final Profile? currentProfile;
  final bool shouldPersonalize;

  final TargetFeed feed;
  final PositiveFeedState feedState;
  final int windowSize;
  final void Function()? onPageLoaded;

  final Widget? emptyDataWidget;
  final Widget? noPostsWidget;

  final bool isSliver;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';
  static const int kCacheExtentHeightMultiplier = 5;

  Future<void> checkForNextPageEntries() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);
    logger.d('Checking for next page entries for feed: ${feed.targetSlug}');

    try {
      final EndpointResponse endpointResponse = await postApiService.listActivities(
        targetSlug: feed.targetSlug,
        targetUserId: feed.targetUserId,
        shouldPersonalize: shouldPersonalize,
        pagination: const Pagination(cursor: ''),
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      final bool hasNewEntries = appendPotentialNewEntries(data);
      if (hasNewEntries) {
        logger.d('checkForNextPageEntries() - New entries found, saving state');
        saveActivitiesState();
      }
    } catch (ex) {
      logger.e('checkForNextPageEntries() - ex: $ex');
    }
  }

  Future<void> requestPreviousPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String profileId = profileController.currentProfile?.flMeta?.id ?? '';

    try {
      final EndpointResponse endpointResponse = await postApiService.listActivities(
        targetSlug: feed.targetSlug,
        targetUserId: feed.targetUserId,
        shouldPersonalize: shouldPersonalize,
        pagination: Pagination(
          cursor: feedState.currentPaginationKey,
        ),
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String? next = data.containsKey('next') ? data['next'].toString() : null;

      // Check for weird backend loops (extra safety)
      if (next == feedState.currentPaginationKey) {
        next = null;
      }

      appendActivityPageToState(data, next);
      saveActivitiesState();
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      activitiesController.notifyPageError(profileId: profileId, feed: feed, error: ex);
    }
  }

  void appendActivityPageToState(Map<String, dynamic> data, String? next) {
    final Logger logger = providerContainer.read(loggerProvider);

    final List<dynamic> activityData = data['activities'] as List<dynamic>;
    final List<Activity> activities = [];

    for (final dynamic activity in activityData) {
      final Map<String, dynamic> activityMap = activity as Map<String, dynamic>;
      final Activity activityObject = Activity.fromJson(activityMap);
      final String activityId = activityObject.flMeta?.id ?? '';

      if (activityId.isEmpty) {
        continue;
      }

      if (feedState.knownActivities.contains(activityId)) {
        continue;
      }

      feedState.knownActivities.add(activityId);
      activities.add(activityObject);
    }

    if (activities.isEmpty) {
      logger.d('appendActivityPageToState() - No activities to append');
      feedState.pagingController.appendLastPage([]);
      return;
    }

    logger.d('appendActivityPageToState() - activityList.length: ${activities.length}');
    feedState.currentPaginationKey = next ?? '';
    feedState.pagingController.appendSafePage(activities, next ?? '');
  }

  bool appendPotentialNewEntries(Map<String, dynamic> data) {
    final Logger logger = providerContainer.read(loggerProvider);

    final List<dynamic> activityData = data['activities'] as List<dynamic>;
    final List<Activity> newActivities = [];

    for (final dynamic activity in activityData) {
      final Map<String, dynamic> activityMap = activity as Map<String, dynamic>;
      final Activity activityObject = Activity.fromJson(activityMap);
      final String activityId = activityObject.flMeta?.id ?? '';

      if (activityId.isEmpty) {
        continue;
      }

      if (feedState.knownActivities.contains(activityId)) {
        continue;
      }

      feedState.knownActivities.add(activityId);
      newActivities.add(activityObject);
    }

    if (newActivities.isEmpty) {
      logger.d('appendPotentialNewEntries() - No activities to append');
      return false;
    }

    logger.d('appendPotentialNewEntries() - activityList.length: ${newActivities.length}');

    // Create a new copy of the item list, appending the new items to the start
    final List<Activity> currentItems = feedState.pagingController.itemList ?? [];
    final List<Activity> newItems = [...newActivities, ...currentItems];
    feedState.pagingController.value = PagingState<String, Activity>(
      itemList: newItems,
      error: null,
      nextPageKey: feedState.pagingController.nextPageKey,
    );

    // Add a flag so that the UI can let the user know that new items have been found!
    feedState.hasNewItems = true;
    return true;
  }

  void saveActivitiesState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    if (feedState.pagingController.value.error != null || feedState.pagingController.value.status == PagingStatus.loadingFirstPage) {
      logger.d('saveActivitiesState() - Not saving activities due to error or loading');
      return;
    }

    feedState.hasPerformedInitialLoad = true;
    if (feedState.pagingController.itemList?.isEmpty ?? true) {
      logger.d('saveActivitiesState() - No activities to save');
      feedState.pagingController.value = PagingState<String, Activity>(
        itemList: feedState.pagingController.itemList,
        error: null,
        nextPageKey: null,
      );
    }

    logger.d('saveActivitiesState() - Saving activities');
    final String newCacheKey = feedState.buildCacheKey();
    cacheController.add(key: newCacheKey, value: feedState);
  }

  bool checkShouldDisplayNoPosts({
    Profile? currentProfile,
  }) {
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final bool requestedFirstWindow = feedState.hasPerformedInitialLoad;
    if (!requestedFirstWindow) {
      return false;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Iterable<Activity>? activities = feedState.pagingController.itemList;
    final bool canDisplayAny = activities?.any((element) {
          final String publisherId = element.publisherInformation?.publisherId ?? '';
          if (currentProfileId.isNotEmpty && publisherId == currentProfileId) {
            return true;
          }

          final String relationshipId = [publisherId, currentProfile?.flMeta?.id ?? ''].asGUID;
          final Relationship? relationship = cacheController.get(relationshipId);
          return element.canDisplayOnFeed(
            currentProfile: currentProfile,
            relationshipWithActivityPublisher: relationship,
            hideWhenMatchesPromotionKey: true,
          );
        }) ??
        false;

    return !canDisplayAny;
  }

  void notifySeenItems() {
    if (!feedState.hasNewItems) {
      return;
    }

    feedState.hasNewItems = false;
    saveActivitiesState();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    usePagingController(
      controller: feedState.pagingController,
      onPreviousPage: requestPreviousPage,
      onNextPage: checkForNextPageEntries,
    );

    useEventHook<NotifyFeedSeedEvent>(
      onEvent: (_) {
        notifySeenItems();
      },
    );

    useEventHook<RequestRefreshEvent>(
      onEvent: (_) {
        feedState.onRefresh();
      },
    );

    final bool shouldDisplayNoPosts = checkShouldDisplayNoPosts(currentProfile: currentProfile);

    final Widget defaultNoPostsSliverWidget = SliverNoPostsPlaceholder(
      typography: typography,
      colors: colors,
      emptyDataWidget: emptyDataWidget,
    );

    final Widget defaultNoPostsWidget = NoPostsPlaceholder(
      typography: typography,
      colors: colors,
    );

    if (shouldDisplayNoPosts && noPostsWidget != null) {
      return noPostsWidget!;
    } else if (shouldDisplayNoPosts) {
      return defaultNoPostsSliverWidget;
    }

    const Widget loadingIndicator = PositivePostLoadingIndicator();
    if (isSliver) {
      return buildSliverFeed(
        context: context,
        loadingIndicator: loadingIndicator,
        noPostsWidget: defaultNoPostsWidget,
      );
    } else {
      return buildFeed(
        context: context,
        loadingIndicator: loadingIndicator,
      );
    }
  }

  static Widget buildVisualSeparator(
    BuildContext context, {
    Widget? parent,
    Color? color,
    double vPadding = kPaddingSmall,
  }) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    // Keep it classy. :D
    final Widget separator = Padding(
      padding: EdgeInsets.symmetric(vertical: vPadding),
      child: Container(
        height: 2.0,
        decoration: BoxDecoration(
          color: color ?? colors.white,
        ),
      ),
    );

    if (parent != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          parent,
          const SizedBox(height: kPaddingExtraSmall),
          separator,
        ],
      );
    }

    return separator;
  }

  Widget buildSeparator(BuildContext context, int index) {
    final Activity? activity = feedState.pagingController.itemList?.elementAtOrNull(index);
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String targetProfileId = activity?.publisherInformation?.publisherId ?? '';

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String relationshipId = [targetProfileId, currentProfileId].asGUID;
    final Relationship? relationship = cacheController.get(relationshipId);

    final Widget? promotedPost = getPromotedPostFromIndex(
      index: index,
      promotionType: PromotionType.feed,
      context: context,
      feed: feed,
      relationship: relationship,
    );

    final bool hasContent = doesItemHaveContent(feed: feed, item: activity ?? const Activity());
    if (!hasContent) {
      return const SizedBox.shrink();
    }

    final bool meetsRelationshipCheck = meetsRelationshipCheckForDisplay(relationship: relationship);
    if (!meetsRelationshipCheck) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildVisualSeparator(context),
        if (promotedPost != null) ...<Widget>[
          promotedPost,
          buildVisualSeparator(context),
        ],
      ],
    );
  }

  static Widget? getPromotedPostFromIndex({
    required int index,
    required PromotionType promotionType,
    required BuildContext context,
    required TargetFeed feed,
    Relationship? relationship,
  }) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final PromotionsController promotionsController = providerContainer.read(promotionsControllerProvider.notifier);
    final Promotion? promotion = promotionsController.getPromotionFromIndex(
      index: index,
      promotionType: PromotionType.feed,
    );

    if (promotion == null) {
      return null;
    }

    final Activity? promotedActivity = cacheController.get(promotion.activityId);
    if (promotedActivity == null) {
      return null;
    }

    // Check the relationship for the promoted activity
    final Profile? currentProfile = profileController.currentProfile;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String promotedActivityPublisherId = promotedActivity.publisherInformation?.publisherId ?? '';
    final String promotedActivityRelationshipId = [promotedActivityPublisherId, currentProfileId].asGUID;
    final Relationship? promotedActivityRelationship = cacheController.get(promotedActivityRelationshipId);

    final bool canDisplayPromotedActivity = promotedActivity.canDisplayOnFeed(currentProfile: currentProfile, relationshipWithActivityPublisher: promotedActivityRelationship);
    if (!canDisplayPromotedActivity) {
      return null;
    }

    final bool meetsRelationshipCheck = meetsRelationshipCheckForDisplay(relationship: relationship);
    if (!meetsRelationshipCheck) {
      return null;
    }

    return buildItem(
      currentProfile: currentProfile,
      feed: feed,
      context: context,
      item: promotedActivity,
      index: index,
      promotion: promotion,
    );
  }

  static bool doesItemHaveContent({
    required TargetFeed? feed,
    required Activity item,
    Relationship? relationship,
  }) {
    final String activityId = item.flMeta?.id ?? '';
    final String publisherId = item.publisherInformation?.publisherId ?? '';
    if (activityId.isEmpty || publisherId.isEmpty) {
      return false;
    }

    // Check promotion is valid for rare feed states
    final bool isClipFeed = feed?.targetSlug == 'tags' && feed?.targetUserId == 'clip';
    final bool isPostFeed = feed?.targetSlug == 'tags' && feed?.targetUserId == 'post';
    final ActivityGeneralConfigurationType? type = item.generalConfiguration?.type;

    // Check if is a clip and we're not on the clip feed
    if (isClipFeed && type != const ActivityGeneralConfigurationType.clip()) {
      return false;
    }

    // Check if is a post and we're not on the post feed
    if (isPostFeed && type != const ActivityGeneralConfigurationType.post()) {
      return false;
    }

    // else there is enough content to show
    return true;
  }

  static bool meetsRelationshipCheckForDisplay({
    Relationship? relationship,
  }) {
    if (relationship != null) {
      final String currentProfileId = providerContainer.read(profileControllerProvider.select((value) => value.currentProfile?.flMeta?.id)) ?? '';
      final Set<RelationshipState> states = relationship.relationshipStatesForEntity(currentProfileId);
      final bool isBlocked = states.contains(RelationshipState.targetBlocked);
      final bool isHidden = states.contains(RelationshipState.sourceHidden);
      if (isBlocked || isHidden) {
        return false;
      }
    }

    return true;
  }

  static Widget buildItem({
    required Profile? currentProfile,
    required TargetFeed? feed,
    required BuildContext context,
    required Activity item,
    required int index,
    Promotion? promotion,
  }) {
    final String activityId = item.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String publisherId = item.publisherInformation?.publisherId ?? '';
    final String reposterId = item.repostConfiguration?.targetActivityPublisherId ?? '';

    if (!doesItemHaveContent(feed: feed, item: item)) {
      return const SizedBox.shrink();
    }

    final String relationshipId = [publisherId, currentProfileId].asGUID;
    final String reposterRelationshipId = [reposterId, currentProfileId].asGUID;

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [item]).toList();

    return PositiveCacheWidget(
      currentProfile: currentProfile,
      cacheObjects: expectedCacheKeys,
      onBuild: (context) => buildWidgetForFeed(
        activityId: activityId,
        currentProfileId: currentProfileId,
        feed: feed ?? const TargetFeed(),
        item: item,
        index: index,
        relationshipId: relationshipId,
        reposterRelationshipId: reposterRelationshipId,
        promotion: promotion,
      ),
    );
  }

  static Widget buildWidgetForFeed({
    required String activityId,
    required String currentProfileId,
    required TargetFeed feed,
    required Activity item,
    required int index,
    required String relationshipId,
    required String reposterRelationshipId,
    Promotion? promotion,
  }) {
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Relationship? relationship = cacheController.get(relationshipId);

    final Activity? activity = cacheController.get(activityId);
    final Profile? targetProfile = cacheController.get(activity?.publisherInformation?.publisherId ?? '');
    final Profile? currentProfile = cacheController.get(currentProfileId);
    // final Promotion? promotion = cacheController.get(activity?.enrichmentConfiguration?.promotionKey ?? '');

    final Profile? reposterProfile = cacheController.get(activity?.repostConfiguration?.targetActivityPublisherId ?? '');
    final Relationship? reposterRelationship = cacheController.get(reposterRelationshipId);
    final Activity? reposterActivity = cacheController.get(activity?.repostConfiguration?.targetActivityId ?? '');
    final String reposterActivityId = reposterActivity?.flMeta?.id ?? '';

    final PromotionsController promotionsController = providerContainer.read(promotionsControllerProvider.notifier);
    final Promotion? reposterPromotion = promotionsController.getPromotionFromActivityId(activityId: reposterActivityId, promotionType: PromotionType.feed);

    final bool canDisplay = activity?.canDisplayOnFeed(
          currentProfile: currentProfile,
          relationshipWithActivityPublisher: relationship,
          hideWhenMatchesPromotionKey: true,
        ) ??
        false;

    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    final String activityReactionStatisticsCacheKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: activityId);
    final ReactionStatistics? activityReactionStatistics = cacheController.get(activityReactionStatisticsCacheKey);

    final String activityRepostReactionStatisticsCacheKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: activity?.repostConfiguration?.targetActivityId ?? '');
    final ReactionStatistics? activityRepostReactionStatistics = cacheController.get(activityRepostReactionStatisticsCacheKey);

    final List<String> expectedUniqueReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: activity, currentProfile: currentProfile).toList();
    final List<Reaction> activityProfileReactions = cacheController.list(expectedUniqueReactionKeys);

    final List<String> expectedUniqueRepostReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: reposterActivity, currentProfile: currentProfile).toList();
    final List<Reaction> activityRepostProfileReactions = cacheController.list(expectedUniqueRepostReactionKeys);

    return PositiveActivityWidget(
      activity: item,
      activityReactionStatistics: activityReactionStatistics,
      activityPromotion: promotion,
      currentProfile: currentProfile,
      activityProfileReactions: activityProfileReactions,
      reposterReactionStatistics: activityRepostReactionStatistics,
      reposterActivityProfileReactions: activityRepostProfileReactions,
      targetProfile: targetProfile,
      targetRelationship: relationship,
      reposterProfile: reposterProfile,
      reposterRelationship: reposterRelationship,
      reposterActivity: reposterActivity,
      reposterPromotion: reposterPromotion,
      targetFeed: feed,
      index: index,
    );
  }

  // Since we can display an entire users feed, if we were to hide posts; then that will hide the entire feed
  // This will cause the pagination to loop forever, so we need to disable the presentation of the sliver feed
  bool get canDisplaySliverFeed {
    final bool isUserFeed = feed.targetSlug == 'users';
    if (!isUserFeed) {
      return true;
    }

    final String userId = feed.targetUserId;
    final String currentUserId = providerContainer.read(profileControllerProvider.select((value) => value.currentProfile?.flMeta?.id)) ?? '';
    if (currentUserId.isEmpty) {
      return true;
    }

    final String guid = [userId, currentUserId].asGUID;
    final Relationship? relationship = providerContainer.read(cacheControllerProvider).get(guid);
    if (relationship == null) {
      return true;
    }

    // If the target has blocked us, or we have hidden their posts; then we can't display the feed
    final Set<RelationshipState> states = relationship.relationshipStatesForEntity(currentUserId);
    return !states.contains(RelationshipState.targetBlocked) && !states.contains(RelationshipState.sourceHidden);
  }

  Widget buildSliverFeed({
    required BuildContext context,
    required Widget loadingIndicator,
    required Widget noPostsWidget,
  }) {
    final bool canDisplay = canDisplaySliverFeed;
    if (!canDisplay) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return PagedSliverList.separated(
      pagingController: feedState.pagingController,
      separatorBuilder: buildSeparator,
      addAutomaticKeepAlives: true,
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        noItemsFoundIndicatorBuilder: (context) => noPostsWidget,
        itemBuilder: (_, item, index) => buildItem(
          currentProfile: currentProfile,
          feed: feed,
          context: context,
          item: item,
          index: index,
        ),
      ),
    );
  }

  Widget buildFeed({
    required BuildContext context,
    required Widget loadingIndicator,
  }) {
    final bool canDisplay = canDisplaySliverFeed;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    return PagedListView.separated(
      pagingController: feedState.pagingController,
      separatorBuilder: buildSeparator,
      addAutomaticKeepAlives: true,
      cacheExtent: MediaQuery.of(context).size.height * kCacheExtentHeightMultiplier,
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        itemBuilder: (_, item, index) => buildItem(
          context: context,
          item: item,
          index: index,
          currentProfile: currentProfile,
          feed: feed,
        ),
      ),
    );
  }
}
