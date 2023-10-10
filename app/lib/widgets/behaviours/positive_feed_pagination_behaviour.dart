// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// Flutter imports:
import 'package:app/extensions/localization_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/paging_controller_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/behaviours/positive_cache_widget.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends HookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.currentProfile,
    required this.feed,
    required this.feedState,
    this.windowSize = 20,
    this.isSliver = true,
    this.onPageLoaded,
    this.emptyDataWidget,
    super.key,
  });

  final Profile? currentProfile;
  final TargetFeed feed;
  final PositiveFeedState feedState;
  final int windowSize;
  final void Function()? onPageLoaded;
  final Widget? emptyDataWidget;

  final bool isSliver;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String profileId = profileController.currentProfile?.flMeta?.id ?? '';

    try {
      final EndpointResponse endpointResponse = await postApiService.listActivities(
        targetSlug: feed.targetSlug,
        targetUserId: feed.targetUserId,
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
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      activitiesController.notifyPageError(profileId: profileId, feed: feed, error: ex);
    } finally {
      saveActivitiesState();
    }
  }

  void appendActivityPageToState(Map<String, dynamic> data, String? next) {
    final Logger logger = providerContainer.read(loggerProvider);

    final List<dynamic> activities = data['activities'] as List<dynamic>;
    final List<Activity> activityList = activities.map((dynamic activity) {
      final Map<String, dynamic> activityMap = activity as Map<String, dynamic>;
      return Activity.fromJson(activityMap);
    }).toList();

    logger.d('appendActivityPageToState() - activityList.length: ${activityList.length}');
    feedState.pagingController.appendPage(activityList, next);
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
    Relationship? relationship,
  }) {
    final bool requestedFirstWindow = feedState.hasPerformedInitialLoad;
    if (!requestedFirstWindow) {
      return false;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Iterable<Activity>? activities = feedState.pagingController.itemList;
    final bool canDisplayAny = activities?.any((element) {
          final String publisherId = element.publisherInformation?.publisherId ?? '';
          final String relationshipId = [publisherId, currentProfile?.flMeta?.id ?? ''].asGUID;
          final Relationship? relationship = cacheController.get(relationshipId);
          return element.canDisplayOnFeed(currentProfile, relationship);
        }) ??
        false;

    return !canDisplayAny;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    usePagingController(
      controller: feedState.pagingController,
      listener: requestNextPage,
    );

    final bool shouldDisplayNoPosts = checkShouldDisplayNoPosts();
    final Widget noPostsSliverWidget = SliverNoPostsPlaceholder(
      typography: typography,
      colors: colors,
      emptyDataWidget: emptyDataWidget,
    );

    final Widget noPostsWidget = NoPostsPlaceholder(
      typography: typography,
      colors: colors,
    );

    if (shouldDisplayNoPosts) {
      return noPostsSliverWidget;
    }

    const Widget loadingIndicator = PositivePostLoadingIndicator();
    if (isSliver) {
      return buildSliverFeed(context, loadingIndicator, noPostsWidget);
    } else {
      return buildFeed(context, loadingIndicator);
    }
  }

  Widget buildSeparator(BuildContext context, int index) {
    final Activity? activity = feedState.pagingController.itemList?.elementAtOrNull(index);
    final String activityId = activity?.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (activityId.isEmpty || currentProfileId.isEmpty) {
      return const SizedBox(height: kPaddingLarge);
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String relationshipId = [activityId, currentProfileId].asGUID;
    final Relationship? relationship = cacheController.get(relationshipId);

    // Remove the separator if we can't display the activity
    final bool canDisplay = activity?.canDisplayOnFeed(currentProfile, relationship) ?? false;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    return const SizedBox(height: kPaddingLarge);
  }

  Widget buildItem(BuildContext context, Activity item, int index) {
    final Activity? tempActivity = feedState.pagingController.itemList?.elementAtOrNull(index);
    final String activityId = tempActivity?.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (activityId.isEmpty || currentProfileId.isEmpty) {
      return const SizedBox.shrink();
    }

    final String relationshipId = [activityId, currentProfileId].asGUID;
    final String reposterRelationshipId = [tempActivity?.repostConfiguration?.targetActivityPublisherId ?? '', currentProfile?.flMeta?.id ?? ''].asGUID;

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [tempActivity]).toList();

    return PositiveCacheWidget(
      currentProfile: currentProfile,
      cacheObjects: expectedCacheKeys,
      onBuild: (context) => buildWidgetForFeed(
        activityId: activityId,
        currentProfileId: currentProfileId,
        feed: feed,
        item: item,
        index: index,
        relationshipId: relationshipId,
        reposterRelationshipId: reposterRelationshipId,
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
  }) {
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Relationship? relationship = cacheController.get(relationshipId);

    final Activity? activity = cacheController.get(activityId);
    final Profile? targetProfile = cacheController.get(activity?.publisherInformation?.publisherId ?? '');
    final Profile? currentProfile = cacheController.get(currentProfileId);
    final Promotion? promotion = cacheController.get(activity?.enrichmentConfiguration?.promotionKey ?? '');

    final Profile? reposterProfile = cacheController.get(activity?.repostConfiguration?.targetActivityPublisherId ?? '');
    final Relationship? reposterRelationship = cacheController.get(reposterRelationshipId);

    final bool canDisplay = activity?.canDisplayOnFeed(currentProfile, relationship) ?? false;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    final String activityReactionStatisticsCacheKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: activityId);
    final ReactionStatistics? activityReactionStatistics = cacheController.get(activityReactionStatisticsCacheKey);

    final List<String> expectedUniqueReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: activity, currentProfile: currentProfile).toList();
    final List<Reaction> currentProfileReactions = cacheController.list(expectedUniqueReactionKeys);

    final String reactionsFeedStateCacheKey = PositiveReactionsState.buildReactionsCacheKey(
      activityId: activityId,
      profileId: currentProfileId,
    );

    final PositiveReactionsState? activityReactionFeedState = cacheController.get(reactionsFeedStateCacheKey);

    return PositiveActivityWidget(
      activity: item,
      activityReactionStatistics: activityReactionStatistics,
      activityPromotion: promotion,
      currentProfile: currentProfile,
      currentProfileReactions: currentProfileReactions,
      activityReactionFeedState: activityReactionFeedState,
      targetProfile: targetProfile,
      targetRelationship: relationship,
      reposterProfile: reposterProfile,
      reposterRelationship: reposterRelationship,
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

  Widget buildSliverFeed(BuildContext context, Widget loadingIndicator, Widget noPostsWidget) {
    final bool canDisplay = canDisplaySliverFeed;
    if (!canDisplay) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return PagedSliverList.separated(
      pagingController: feedState.pagingController,
      separatorBuilder: buildSeparator,
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        noItemsFoundIndicatorBuilder: (context) => noPostsWidget,
        itemBuilder: (_, item, index) => buildItem(context, item, index),
      ),
    );
  }

  Widget buildFeed(BuildContext context, Widget loadingIndicator) {
    final bool canDisplay = canDisplaySliverFeed;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    return PagedListView.separated(
      pagingController: feedState.pagingController,
      separatorBuilder: buildSeparator,
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        itemBuilder: (_, item, index) => buildItem(context, item, index),
      ),
    );
  }
}

class SliverNoPostsPlaceholder extends StatelessWidget {
  const SliverNoPostsPlaceholder({
    super.key,
    required this.typography,
    required this.colors,
    this.emptyDataWidget,
  });

  final DesignTypographyModel typography;
  final DesignColorsModel colors;
  final Widget? emptyDataWidget;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return SliverStack(
      positionedAlignment: Alignment.bottomCenter,
      children: <Widget>[
        SliverPositioned(
          left: 0.0,
          right: 0.0,
          top: kPaddingSmall,
          child: Align(
            alignment: Alignment.topCenter,
            child: emptyDataWidget ??
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120.0),
                  child: Text(
                    appLocalizations.post_dialog_no_posts_to_display,
                    textAlign: TextAlign.center,
                    style: typography.styleSubtitleBold.copyWith(color: colors.colorGray8, fontWeight: FontWeight.w900),
                  ),
                ),
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: decorationBoxSize,
              width: decorationBoxSize,
              child: Stack(children: buildType2ScaffoldDecorations(colors)),
            ),
          ),
        ),
      ],
    );
  }
}

class NoPostsPlaceholder extends StatelessWidget {
  const NoPostsPlaceholder({
    super.key,
    required this.typography,
    required this.colors,
  });

  final DesignTypographyModel typography;
  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: kPaddingSmall,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120.0),
              child: Text(
                'No Posts to Display',
                textAlign: TextAlign.center,
                style: typography.styleSubtitleBold.copyWith(color: colors.colorGray8, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PositiveTileEntryAnimation(
            direction: AxisDirection.down,
            child: SizedBox(
              height: decorationBoxSize,
              width: decorationBoxSize,
              child: Stack(children: buildType2ScaffoldDecorations(colors)),
            ),
          ),
        ),
      ],
    );
  }
}
