// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/providers/events/content/activity_events.dart';

class PositiveFeedState {
  PositiveFeedState({
    required this.feed,
    required this.profileId,
    required this.pagingController,
    this.currentPaginationKey = '',
    this.hasPerformedInitialLoad = false,
  });

  final TargetFeed feed;
  final String profileId;
  final PagingController<String, Activity> pagingController;

  bool hasPerformedInitialLoad;
  String currentPaginationKey;
}
