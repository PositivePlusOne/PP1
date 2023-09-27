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
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/common/events/force_feed_rebuild_event.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
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

  final bool isSliver;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => PositiveFeedPaginationBehaviourState();
}

class PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late PositiveFeedState feedState;

  StreamSubscription<CacheKeyUpdatedEvent>? _onCacheKeyUpdatedSubscription;
  StreamSubscription<ForceFeedRebuildEvent>? _onForceFeedRebuildSubscription;

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

  static String getExpectedCacheKey({
    required String profileId,
    required TargetFeed feed,
  }) =>
      'feeds:$profileId:${feed.feed}-${feed.slug}';

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _onCacheKeyUpdatedSubscription?.cancel();
    await _onForceFeedRebuildSubscription?.cancel();

    _onCacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
    _onForceFeedRebuildSubscription = eventBus.on<ForceFeedRebuildEvent>().listen((_) => setStateIfMounted());
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is! PositiveFeedState) {
      return;
    }

    final PositiveFeedState feedState = event.value as PositiveFeedState;
    if (feedState.feed.feed != widget.feed.feed || feedState.feed.slug != widget.feed.slug) {
      setStateIfMounted();
    }
  }

  Future<void> disposeListeners() async {
    await _onCacheKeyUpdatedSubscription?.cancel();
    await _onForceFeedRebuildSubscription?.cancel();
  }

  void disposeFeedState() {
    feedState.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupFeedState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String profileId = profileController.currentProfile?.flMeta?.id ?? '';

    logger.d('setupFeedState() - Loading state for ${widget.feed}');
    feedState = activitiesController.getOrCreateFeedStateForOrigin(
      feed: widget.feed,
      profileId: profileId,
    );

    final PagingController<String, Activity> pagingController = PagingController<String, Activity>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String profileId = profileController.currentProfile?.flMeta?.id ?? '';

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

      activitiesController.notifyPageKeyUpdated(
        feed: widget.feed,
        pageKey: next,
        profileId: profileId,
      );
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      activitiesController.notifyPageError(profileId: profileId, feed: widget.feed, error: ex);
    }
  }

  bool checkShouldDisplayNoPosts() {
    final bool requestedFirstWindow = feedState.hasPerformedInitialLoad;
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
    final Relationship? relationship = providerContainer.read(cacheControllerProvider).get(guid);
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
