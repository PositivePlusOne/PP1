// Dart imports:

// Package imports:
import 'package:app/widgets/state/positive_pagination_controller_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/providers/events/content/activity_events.dart';

class PositiveFeedState with PositivePaginationControllerState {
  PositiveFeedState({
    required this.pagingController,
    required this.feed,
    required this.profileId,
    this.currentPaginationKey = '',
    this.hasPerformedInitialLoad = false,
  });

  @override
  final PagingController<String, Activity> pagingController;

  final TargetFeed feed;
  final String profileId;

  bool hasPerformedInitialLoad;
  String currentPaginationKey;

  @override
  String buildCacheKey() {
    return buildFeedCacheKey(feed);
  }

  static String buildFeedCacheKey(TargetFeed feed) {
    return 'feed:paging:${feed.feed}:${feed.slug}';
  }
}
