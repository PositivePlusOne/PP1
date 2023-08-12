// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/comments.dart';

class PositiveCommentsState {
  PositiveCommentsState({
    required this.activityId,
    required this.pagingController,
    required this.currentPaginationKey,
  });

  final String activityId;
  final PagingController<String, Comment> pagingController;
  String currentPaginationKey;
}
