// Dart imports:
import 'dart:async';

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';

class PositiveFeedState {
  PositiveFeedState({
    required this.feed,
    required this.slug,
    required this.pagingController,
    required this.currentPaginationKey,
  });

  final String feed;
  final String slug;
  final PagingController<String, Activity> pagingController;
  String currentPaginationKey;
}
