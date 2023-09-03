// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';

class PositiveReactionsState {
  PositiveReactionsState({
    required this.activityId,
    required this.kind,
    required this.pagingController,
    required this.currentPaginationKey,
  });

  final String activityId;
  final String kind;
  final PagingController<String, Reaction> pagingController;

  String currentPaginationKey;
}
