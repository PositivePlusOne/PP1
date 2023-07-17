// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    required this.slug,
    this.windowSize = 10,
    super.key,
  });

  final String feed;
  final String slug;
  final int windowSize;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => _PositiveFeedPaginationBehaviourState();
}

class _PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late final PagingController<String, Activity> pagingController;
  String currentPaginationKey = '';

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void didUpdateWidget(PositiveFeedPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feed != widget.feed || oldWidget.slug != widget.slug) {
      disposeListeners();
      setupListeners();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    pagingController = PagingController<String, Activity>(firstPageKey: currentPaginationKey);
    pagingController.addPageRequestListener(requestNextPage);
  }

  void disposeListeners() {
    pagingController.removePageRequestListener(requestNextPage);
    pagingController.dispose();
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

    try {
      final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
      final EndpointResponse endpointResponse = await systemApiService.getFeedWindow(widget.feed, widget.slug, cursor: pageKey);

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      final String next = data.containsKey('next') ? data['next'].toString() : '';

      appendActivityPage(data, next);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      if (mounted) {
        pagingController.error = ex;
      }
    }
  }

  void appendActivityPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = ref.read(loggerProvider);
    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != currentPaginationKey;

    currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: $currentPaginationKey');

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
      pagingController.appendLastPage(newActivities);
    } else if (mounted) {
      pagingController.appendPage(newActivities, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = PositivePostLoadingIndicator();
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const Divider(),
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        itemBuilder: (_, item, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: kPaddingMedium),
            child: PositiveTileEntryAnimation(
              direction: AxisDirection.up,
              child: PositiveActivityWidget(
                activity: item,
                index: index,
              ),
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }
}
