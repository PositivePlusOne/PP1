// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

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

  final Set<String> knownActivities = <String>{};

  void appendKnownActivity(String str) {
    knownActivities.add(str);
  }

  void appendKnownActivities(List<String> strs) {
    knownActivities.addAll(strs);
  }

  @override
  String buildCacheKey() {
    return buildFeedCacheKey(feed);
  }

  static PositiveFeedState buildNewState({
    required TargetFeed feed,
    required String currentProfileId,
  }) {
    return PositiveFeedState(
      feed: feed,
      profileId: currentProfileId,
      pagingController: PagingController<String, Activity>(
        firstPageKey: '',
      ),
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

  static String buildFeedCacheKey(TargetFeed feed) {
    return 'feed:paging:${feed.targetSlug}:${feed.targetUserId}';
  }
}
