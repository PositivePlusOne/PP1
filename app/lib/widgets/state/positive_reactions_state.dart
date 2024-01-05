// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveReactionsState with PositivePaginationControllerState {
  PositiveReactionsState({
    required this.profileId,
    required this.pagingController,
    required this.activityId,
    required this.activityOrigin,
    this.currentPaginationKey = '',
  });

  static final PositiveReactionsState emptyState = PositiveReactionsState.createNewFeedState('', '', '');

  @override
  final PagingController<String, Reaction> pagingController;

  final String profileId;
  final String activityId;
  final String activityOrigin;

  String currentPaginationKey;

  ReactionStatistics? _currentStatistics;
  ReactionStatistics? get currentStatistics => _currentStatistics;

  @override
  String buildCacheKey() {
    return buildReactionsCacheKey(
      activityId: activityId,
      activityOrigin: activityOrigin,
      profileId: profileId,
    );
  }

  Future<void> requestRefresh(String cacheKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    logger.d('onRefresh()');
    cacheController.remove(cacheKey);
    pagingController.refresh();

    // Wait until the first page is loaded
    int counter = 0;
    while (pagingController.itemList == null && counter < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      counter++;

      // Check for an error
      if (pagingController.error != null) {
        throw pagingController.error!;
      }
    }

    cacheController.add(key: cacheKey, value: this);
  }

  static PositiveReactionsState createNewFeedState(String activityId, String activityOrigin, String profileId) {
    return PositiveReactionsState(
      profileId: profileId,
      activityId: activityId,
      activityOrigin: activityOrigin,
      pagingController: PagingController<String, Reaction>(
        firstPageKey: '',
      ),
    );
  }

  static String buildReactionsCacheKey({
    required String activityId,
    required String activityOrigin,
    required String profileId,
  }) {
    return 'feed:paging:reactions:$activityId:$activityOrigin:$profileId';
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
