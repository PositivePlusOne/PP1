// Dart imports:

// Package imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
