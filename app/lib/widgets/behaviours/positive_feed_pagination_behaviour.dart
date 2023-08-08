// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    required this.slug,
    this.onPageLoaded,
    this.windowSize = 10,
    super.key,
  });

  final String feed;
  final String slug;
  final int windowSize;

  final Function(Map<String, dynamic>)? onPageLoaded;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => _PositiveFeedPaginationBehaviourState();
}

class _PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late PositiveFeedState feedState;

  StreamSubscription<ActivityCreatedEvent>? _onActivityCreatedSubscription;
  StreamSubscription<ActivityUpdatedEvent>? _onActivityUpdatedSubscription;
  StreamSubscription<ActivityDeletedEvent>? _onActivityDeletedSubscription;

  String get expectedCacheKey => 'feeds:${widget.feed}-${widget.slug}';

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
    if (oldWidget.feed != widget.feed || oldWidget.slug != widget.slug) {
      disposeFeedState();
      setupFeedState();
    }
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _onActivityCreatedSubscription?.cancel();
    await _onActivityUpdatedSubscription?.cancel();
    await _onActivityDeletedSubscription?.cancel();

    _onActivityCreatedSubscription = eventBus.on<ActivityCreatedEvent>().listen(onActivityCreated);
    _onActivityUpdatedSubscription = eventBus.on<ActivityUpdatedEvent>().listen(onActivityUpdated);
    _onActivityDeletedSubscription = eventBus.on<ActivityDeletedEvent>().listen(onActivityDeleted);
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

    logger.d('setupFeedState() - Loading state for ${widget.feed} - ${widget.slug}');
    final PositiveFeedState? cachedFeedState = cacheController.getFromCache(expectedCacheKey);
    if (cachedFeedState != null) {
      logger.d('setupFeedState() - Found cached state for ${widget.feed} - ${widget.slug}');
      feedState = cachedFeedState;
      feedState.pagingController.addPageRequestListener(requestNextPage);
      return;
    }

    logger.d('setupFeedState() - No cached state for ${widget.feed} - ${widget.slug}. Creating new state.');
    final PagingController<String, Activity> pagingController = PagingController<String, Activity>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    feedState = PositiveFeedState(
      feed: widget.feed,
      slug: widget.slug,
      pagingController: pagingController,
      currentPaginationKey: '',
    );
  }

  void saveFeedState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('saveState() - Saving state for ${widget.feed} - ${widget.slug}');
    cacheController.addToCache(key: expectedCacheKey, value: feedState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final SystemApiService systemApiService = await providerContainer.read(systemApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await systemApiService.getFeedWindow(widget.feed, widget.slug, cursor: pageKey);
      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      final String next = data.containsKey('next') ? data['next'].toString() : '';

      appendActivityPage(data, next);
      widget.onPageLoaded?.call(data);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      feedState.pagingController.error = ex;
    } finally {
      saveFeedState();
    }
  }

  void appendActivityPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != feedState.currentPaginationKey;

    feedState.currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: ${feedState.currentPaginationKey}');

    final List<Activity> newActivities = [];
    final List<dynamic> activities = (data.containsKey('activities') ? data['activities'] : []).map((dynamic activity) => json.decodeSafe(activity)).toList();

    for (final dynamic activity in activities) {
      try {
        logger.d('requestNextTimelinePage() - parsing activity: $activity');
        final Activity newActivity = Activity.fromJson(activity);
        final String activityId = newActivity.flMeta?.id ?? '';

        if (activityId.isEmpty || !newActivity.hasContentToDisplay) {
          logger.e('requestNextTimelinePage() - Failed to parse activity: $activity');
          continue;
        }

        newActivities.add(newActivity);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse activity: $activity - ex: $ex');
      }
    }

    logger.d('requestNextTimelinePage() - newActivities: $newActivities');

    if (!hasNext && mounted) {
      feedState.pagingController.appendLastPage(newActivities);
    } else if (mounted) {
      feedState.pagingController.appendPage(newActivities, nextPageKey);
    }

    saveFeedState();
  }

  void onActivityCreated(ActivityCreatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Activity activity = event.activity;
    if (event.targets.any((element) => element.feed == widget.feed && element.slug == widget.slug)) {
      feedState.pagingController.itemList?.insert(0, activity);
      feedState.pagingController.itemList = feedState.pagingController.itemList;

      logger.d('onActivityCreated() - Added activity to feed: ${widget.feed} - ${widget.slug} - activity: $activity');
      setStateIfMounted();
    }
  }

  void onActivityUpdated(ActivityUpdatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Activity activity = event.activity;
    if (event.targets.any((element) => element.feed == widget.feed && element.slug == widget.slug)) {
      final int index = feedState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == activity.flMeta?.id) ?? -1;
      if (index >= 0) {
        feedState.pagingController.itemList?[index] = activity;
        feedState.pagingController.itemList = feedState.pagingController.itemList;

        logger.d('onActivityUpdated() - Updated activity in feed: ${widget.feed} - ${widget.slug} - activity: $activity');
        setStateIfMounted();
      }
    }
  }

  void onActivityDeleted(ActivityDeletedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    if (event.targets.any((element) => element.feed == widget.feed && element.slug == widget.slug)) {
      final int index = feedState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == event.activityId) ?? -1;
      if (index >= 0) {
        feedState.pagingController.itemList?.removeAt(index);
        feedState.pagingController.itemList = feedState.pagingController.itemList;

        logger.d('onActivityDeleted() - Deleted activity in feed: ${widget.feed} - ${widget.slug} - activityId: ${event.activityId}');
        setStateIfMounted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = PositivePostLoadingIndicator();
    return PagedSliverList.separated(
      pagingController: feedState.pagingController,
      separatorBuilder: (context, index) => const Divider(),
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        itemBuilder: (_, item, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: kPaddingMedium),
            child: PositiveActivityWidget(
              activity: item,
              index: index,
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }
}
