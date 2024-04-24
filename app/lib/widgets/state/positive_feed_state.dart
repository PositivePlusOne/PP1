// Dart imports:

// Package imports:
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveFeedState with PositivePaginationControllerState {
  PositiveFeedState({
    required this.pagingController,
    required this.feed,
    required this.profileId,
    this.currentPaginationKey = '',
    this.hasPerformedInitialLoad = false,
    this.hasNewItems = false,
  });

  @override
  final PagingController<String, Activity> pagingController;

  final TargetFeed feed;
  final String profileId;

  bool hasPerformedInitialLoad;
  String currentPaginationKey;

  bool hasNewItems;

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

  Future<void> onRefresh() => runWithMutex(
        () async {
          final Logger logger = providerContainer.read(loggerProvider);
          final CacheController cacheController = providerContainer.read(cacheControllerProvider);
          final FirebaseRemoteConfig remoteConfig = await providerContainer.read(firebaseRemoteConfigProvider.future);

          final int feedRefreshTimeout = remoteConfig.getInt(SystemController.kFirebaseRemoteConfigFeedRefreshTimeoutKey);
          final Duration feedRefreshTimeoutDuration = Duration(seconds: feedRefreshTimeout);
          final DateTime timeoutDatetime = DateTime.now().add(feedRefreshTimeoutDuration);

          logger.d('onRefresh()');
          cacheController.remove(buildCacheKey());

          // Wait until the first page is loaded
          bool isSuccessful = false;
          while (DateTime.now().isBefore(timeoutDatetime)) {
            await Future.delayed(feedRefreshTimeoutDuration);

            final PositiveFeedState? feedState = cacheController.get(buildCacheKey());
            if (feedState?.pagingController.itemList?.isNotEmpty == true) {
              isSuccessful = true;
              break;
            }

            // Check for an error
            if (feedState?.pagingController.error != null) {
              throw feedState?.pagingController.error!;
            }
          }

          if (!isSuccessful) {
            throw Exception('Failed to refresh feed');
          }
        },
      );

  static String buildFeedCacheKey(TargetFeed feed) {
    return 'feed:paging:${feed.targetSlug}:${feed.targetUserId}:${feed.shouldPersonalize}';
  }
}
