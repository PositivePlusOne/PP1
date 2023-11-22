// Dart imports:

// Package imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';
import 'package:logger/logger.dart';

class PositiveCommunityFeedState with PositivePaginationControllerState {
  PositiveCommunityFeedState({
    required this.pagingController,
    required this.profileId,
    required this.communityType,
    this.searchQuery = '',
    this.currentPaginationKey = '',
    this.hasPerformedInitialLoad = false,
  });

  @override
  final PagingController<String, String> pagingController;

  final String profileId;
  final CommunityType communityType;

  bool hasPerformedInitialLoad;
  String currentPaginationKey;
  String searchQuery;

  @override
  String buildCacheKey() {
    return buildFeedCacheKey(profileId, communityType, searchQuery);
  }

  static PositiveCommunityFeedState buildNewState({
    required CommunityType communityType,
    required String currentProfileId,
    required String searchQuery,
    PagingController<String, String>? pagingController,
  }) {
    return PositiveCommunityFeedState(
      communityType: communityType,
      profileId: currentProfileId,
      searchQuery: searchQuery,
      pagingController: pagingController ??
          PagingController<String, String>(
            firstPageKey: '',
          ),
    );
  }

  static String buildFeedCacheKey(String profileId, CommunityType communityType, String searchQuery) {
    return 'feed:paging:$profileId:${communityType.name}:$searchQuery';
  }
}
