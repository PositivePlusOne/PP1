// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/common/events/force_feed_rebuild_event.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    this.onPageLoaded,
    this.windowSize = 20,
    this.onHeaderTap,
    this.onMediaTap,
    this.isSliver = true,
    super.key,
  });

  final TargetFeed feed;
  final int windowSize;

  final void Function(Activity activity)? onHeaderTap;
  final void Function(Activity activity, Media media)? onMediaTap;

  final Function(Map<String, dynamic>)? onPageLoaded;

  final bool isSliver;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => _PositiveFeedPaginationBehaviourState();
}

class _PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late PositiveFeedState feedState;

  StreamSubscription<ActivityCreatedEvent>? _onActivityCreatedSubscription;
  StreamSubscription<ActivityUpdatedEvent>? _onActivityUpdatedSubscription;
  StreamSubscription<ActivityDeletedEvent>? _onActivityDeletedSubscription;

  StreamSubscription<ForceFeedRebuildEvent>? _onForceFeedRebuildSubscription;

  String get expectedCacheKey => 'feeds:${widget.feed.feed}-${widget.feed.slug}';

  bool requestedFirstWindow = false;

  @override
  void initState() {
    super.initState();
    setupListeners();
    setupFeedState();
  }

  @override
  void dispose() {
    disposeListeners();
    disposeFeedState();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveFeedPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feed.feed != widget.feed.feed || oldWidget.feed.slug != widget.feed.slug) {
      disposeFeedState();
      setupFeedState();
    }
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _onActivityCreatedSubscription?.cancel();
    await _onActivityUpdatedSubscription?.cancel();
    await _onActivityDeletedSubscription?.cancel();
    await _onForceFeedRebuildSubscription?.cancel();

    _onActivityCreatedSubscription = eventBus.on<ActivityCreatedEvent>().listen(onActivityCreated);
    _onActivityUpdatedSubscription = eventBus.on<ActivityUpdatedEvent>().listen(onActivityUpdated);
    _onActivityDeletedSubscription = eventBus.on<ActivityDeletedEvent>().listen(onActivityDeleted);
    _onForceFeedRebuildSubscription = eventBus.on<ForceFeedRebuildEvent>().listen((_) => setStateIfMounted());
  }

  Future<void> disposeListeners() async {
    await _onActivityCreatedSubscription?.cancel();
    await _onActivityUpdatedSubscription?.cancel();
    await _onActivityDeletedSubscription?.cancel();
  }

  void disposeFeedState() {
    feedState.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupFeedState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('setupFeedState() - Loading state for ${widget.feed}');
    final PositiveFeedState? cachedFeedState = cacheController.getFromCache(expectedCacheKey);
    if (cachedFeedState != null) {
      logger.d('setupFeedState() - Found cached state for ${widget.feed}');
      feedState = cachedFeedState;
      requestedFirstWindow = true;
      feedState.pagingController.addPageRequestListener(requestNextPage);
      return;
    }

    logger.d('setupFeedState() - No cached state for ${widget.feed}. Creating new state.');
    final PagingController<String, Activity> pagingController = PagingController<String, Activity>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    feedState = PositiveFeedState(
      feed: widget.feed.feed,
      slug: widget.feed.slug,
      pagingController: pagingController,
      currentPaginationKey: '',
    );
  }

  void saveFeedState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('saveState() - Saving state for ${widget.feed}');
    cacheController.addToCache(key: expectedCacheKey, value: feedState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await postApiService.listActivities(
        widget.feed.feed,
        widget.feed.slug,
        pagination: Pagination(
          cursor: feedState.currentPaginationKey,
        ),
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String next = data.containsKey('next') ? data['next'].toString() : '';

      // Check for weird backend loops (extra safety)
      if (next == feedState.currentPaginationKey) {
        next = '';
      }

      requestedFirstWindow = true;
      widget.onPageLoaded?.call(data);
      appendActivityPage(data, next);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      feedState.pagingController.error = ex;
    }
  }

  void appendActivityPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = providerContainer.read(loggerProvider);

    feedState.currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - nextPageKey: $nextPageKey - currentPaginationKey: ${feedState.currentPaginationKey}');

    final List<String> windowIds = ((data.containsKey('windowIds') && data['windowIds'] is Iterable ? data['windowIds'] : []) as List).map((dynamic windowId) {
      return windowId is String ? windowId : windowId.toString();
    }).toList();

    final List<dynamic> activitiesRaw = data.containsKey('activities') && data['activities'] is Iterable ? data['activities'] : [];
    final List<Activity> activities = activitiesRaw
        .map((dynamic activity) {
          try {
            final Map<String, dynamic> activityData = json.decodeSafe(activity);
            return Activity.fromJson(activityData);
          } catch (ex) {
            logger.e('requestNextTimelinePage() - ex: $ex');
            return null;
          }
        })
        .whereType<Activity>()
        .where((activity) => activity.flMeta?.id != null && windowIds.contains(activity.flMeta?.id))
        .toList();

    // Remove all activities that are not included in the windowIds
    // This is to prevent showing reposts that are not in the windowIds
    final List<Activity> newActivities = activities.where((element) => windowIds.contains(element.flMeta?.id)).toList();
    final bool hasNext = nextPageKey.isNotEmpty && newActivities.isNotEmpty;

    logger.d('requestNextTimelinePage() - newActivities: $newActivities');

    if (!hasNext) {
      feedState.pagingController.appendSafeLastPage(newActivities);
    } else {
      feedState.pagingController.appendSafePage(newActivities, nextPageKey);
    }

    saveFeedState();
  }

  void onActivityCreated(ActivityCreatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Activity activity = event.activity;
    if (event.targets.any((element) => element.feed == widget.feed.feed && element.slug == widget.feed.slug)) {
      feedState.pagingController.itemList?.insert(0, activity);
      feedState.pagingController.itemList = feedState.pagingController.itemList;

      logger.d('onActivityCreated() - Added activity to feed: ${widget.feed} - activity: $activity');
      setStateIfMounted();
    }
  }

  void onActivityUpdated(ActivityUpdatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Activity activity = event.activity;
    if (event.targets.any((element) => element.feed == widget.feed.feed && element.slug == widget.feed.slug)) {
      final int index = feedState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == activity.flMeta?.id) ?? -1;
      if (index >= 0) {
        feedState.pagingController.itemList?[index] = activity;
        feedState.pagingController.itemList = feedState.pagingController.itemList;

        logger.d('onActivityUpdated() - Updated activity in feed: ${widget.feed} - activity: $activity');
        setStateIfMounted();
      }
    }
  }

  void onActivityDeleted(ActivityDeletedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final String id = event.activity.flMeta?.id ?? '';
    if (id.isEmpty) {
      return;
    }

    if (event.targets.any((element) => element.feed == widget.feed.feed && element.slug == widget.feed.slug)) {
      final int index = feedState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == id) ?? -1;
      if (index >= 0) {
        feedState.pagingController.itemList?.removeAt(index);
        feedState.pagingController.itemList = feedState.pagingController.itemList;

        logger.d('onActivityDeleted() - Deleted activity in feed: ${widget.feed} - activityId: ${event.activity}');
        setStateIfMounted();
      }
    }
  }

  bool checkShouldDisplayNoPosts() {
    if (!requestedFirstWindow) {
      return false;
    }

    final Iterable<Activity>? activities = feedState.pagingController.itemList;
    final bool canDisplayAny = activities?.any((element) => element.canDisplayOnFeed) ?? false;

    return !canDisplayAny;
  }

  @override
  Widget build(BuildContext context) {
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final bool shouldDisplayNoPosts = checkShouldDisplayNoPosts();
    if (shouldDisplayNoPosts) {
      return SliverStack(
        positionedAlignment: Alignment.bottomCenter,
        children: <Widget>[
          SliverPositioned(
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

    const Widget loadingIndicator = PositivePostLoadingIndicator();
    if (widget.isSliver) {
      return buildSliverFeed(context, loadingIndicator);
    } else {
      return buildFeed(context, loadingIndicator);
    }
  }

  Widget buildSeparator(BuildContext context, int index) {
    final Activity? activity = feedState.pagingController.itemList?.elementAtOrNull(index);
    if (activity == null) {
      return const SizedBox(height: kPaddingLarge);
    }

    // Remove the separator if we can't display the activity
    final bool canDisplay = activity.canDisplayOnFeed;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    return const SizedBox(height: kPaddingLarge);
  }

  Widget buildItem(BuildContext context, Activity item, int index) {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool canDisplay = item.canDisplayOnFeed;
    if (!canDisplay) {
      logger.d('buildItem() - Skipping activity: ${item.flMeta?.id} - canDisplay: $canDisplay');
      return const SizedBox.shrink();
    }

    return PositiveActivityWidget(
      key: ValueKey('homeFeedActivity-${item.flMeta?.id}'),
      onImageTapped: widget.onMediaTap != null ? (media) => widget.onMediaTap?.call(item, media) : null,
      onHeaderTapped: widget.onHeaderTap != null ? () => widget.onHeaderTap?.call(item) : null,
      activity: item,
      targetFeed: widget.feed,
      index: index,
    );
  }

  // Since we can display an entire users feed, if we were to hide posts; then that will hide the entire feed
  // This will cause the pagination to loop forever, so we need to disable the presentation of the sliver feed
  bool get canDisplaySliverFeed {
    final bool isUserFeed = widget.feed.feed == 'users';
    if (!isUserFeed) {
      return true;
    }

    final String userId = widget.feed.slug;
    final String currentUserId = providerContainer.read(profileControllerProvider.select((value) => value.currentProfile?.flMeta?.id)) ?? '';
    if (currentUserId.isEmpty) {
      return true;
    }

    final String guid = [userId, currentUserId].asGUID;
    final Relationship? relationship = providerContainer.read(cacheControllerProvider.notifier).getFromCache(guid);
    if (relationship == null) {
      return true;
    }

    // If the target has blocked us, or we have hidden their posts; then we can't display the feed
    final Set<RelationshipState> states = relationship.relationshipStatesForEntity(currentUserId);
    return !states.contains(RelationshipState.targetBlocked) && !states.contains(RelationshipState.sourceHidden);
  }

  Widget buildSliverFeed(BuildContext context, Widget loadingIndicator) {
    final bool canDisplay = canDisplaySliverFeed;
    if (!canDisplay) {
      return const SizedBox.shrink();
    }

    return PagedSliverList.separated(
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
