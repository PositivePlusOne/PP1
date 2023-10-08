// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveReactionsState with PositivePaginationControllerState {
  PositiveReactionsState({
    required this.profileId,
    required this.pagingController,
    required this.activityId,
    this.currentPaginationKey = '',
  });

  static final PositiveReactionsState emptyState = PositiveReactionsState.createNewFeedState('', '');

  @override
  final PagingController<String, Reaction> pagingController;

  final String profileId;
  final String activityId;

  String currentPaginationKey;

  ReactionStatistics? _currentStatistics;
  ReactionStatistics? get currentStatistics => _currentStatistics;

  @override
  String buildCacheKey() {
    return buildReactionsCacheKey(
      activityId: activityId,
      profileId: profileId,
    );
  }

  static PositiveReactionsState createNewFeedState(String activityId, String profileId) {
    return PositiveReactionsState(
      profileId: profileId,
      activityId: activityId,
      pagingController: PagingController<String, Reaction>(
        firstPageKey: '',
      ),
    );
  }

  static String buildReactionsCacheKey({
    required String activityId,
    required String profileId,
  }) {
    return 'feed:paging:reactions:$activityId:$profileId';
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
