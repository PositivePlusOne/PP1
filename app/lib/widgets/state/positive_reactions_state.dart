// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveReactionsState with PositivePaginationControllerState {
  PositiveReactionsState({
    required this.pagingController,
    required this.activityId,
    required this.kind,
    this.currentPaginationKey = '',
  });

  @override
  final PagingController<String, Reaction> pagingController;

  final String activityId;
  final String kind;

  String currentPaginationKey;

  ReactionStatistics? _currentStatistics;
  ReactionStatistics? get currentStatistics => _currentStatistics;

  @override
  String buildCacheKey() {
    return buildReactionsCacheKey(activityId);
  }

  static buildReactionsCacheKey(String activityId) {
    return 'feed:paging:reactions:$activityId';
  }

  void updateReactionStatistics(ReactionStatistics statistics) {
    if (!doStatisticsApply(statistics)) {
      return;
    }

    _currentStatistics = statistics;

    // Ryan: We call into this as the activities do not update, but we may want the UI to update.
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();
  }

  bool doStatisticsApply(ReactionStatistics statistics) {
    return statistics.activityId == activityId;
  }
}
