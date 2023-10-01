// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// Flutter imports:
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
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/content/positive_activity_dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends HookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    this.windowSize = 20,
    this.onHeaderTap,
    this.onMediaTap,
    this.isSliver = true,
    super.key,
  });

  final TargetFeed feed;
  final PositiveFeedState feedState;
  final int windowSize;

  final void Function(Activity activity)? onHeaderTap;
  final void Function(Activity activity, Media media)? onMediaTap;

  final bool isSliver;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  static String getExpectedCacheKey({
    required String profileId,
    required TargetFeed feed,
  }) =>
      'feeds:$profileId:${feed.feed}-${feed.slug}';

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final PostApiService postApiService = await providerContainer.read(postApiServiceProvider.future);
    final ActivitiesController activitiesController = providerContainer.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String profileId = profileController.currentProfile?.flMeta?.id ?? '';

    try {
      final EndpointResponse endpointResponse = await postApiService.listActivities(
        feed.feed,
        feed.slug,
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
        feed: feed,
        pageKey: next,
        profileId: profileId,
      );
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      activitiesController.notifyPageError(profileId: profileId, feed: feed, error: ex);
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
  Widget build(BuildContext context, WidgetRef ref) {
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
    if (isSliver) {
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
      activity: item,
      targetFeed: feed,
      onHeaderTapped: onHeaderTap != null ? () => onHeaderTap?.call(item) : null,
      index: index,
    );
  }

  // Since we can display an entire users feed, if we were to hide posts; then that will hide the entire feed
  // This will cause the pagination to loop forever, so we need to disable the presentation of the sliver feed
  bool get canDisplaySliverFeed {
    final bool isUserFeed = feed.feed == 'users';
    if (!isUserFeed) {
      return true;
    }

    final String userId = feed.slug;
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
