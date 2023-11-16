// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveNotificationsState with PositivePaginationControllerState {
  PositiveNotificationsState({
    required this.pagingController,
    required this.uid,
    required this.currentPaginationKey,
    required this.unreadCount,
    required this.unseenCount,
    required this.hasFirstLoad,
    this.knownGroups = const {},
  });

  @override
  final PagingController<String, NotificationPayload> pagingController;

  final String uid;

  String currentPaginationKey;
  int unreadCount;
  int unseenCount;
  bool hasFirstLoad;
  Set<String> knownGroups;

  @override
  String buildCacheKey() {
    return buildNotificationsCacheKey(uid);
  }

  void appendKnownGroup(String group) {
    knownGroups.add(group);
  }

  static Future<void> requestRefresh(String key) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    logger.d('onRefresh()');
    final PositiveNotificationsState? state = cacheController.get(key);
    if (state == null) {
      return;
    }

    state.knownGroups = {};
    state.pagingController.refresh();

    // Wait until the first page is loaded
    int counter = 0;
    while (state.pagingController.itemList == null && counter < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      counter++;

      // Check for an error
      if (state.pagingController.error != null) {
        throw state.pagingController.error!;
      }
    }

    cacheController.add(key: key, value: state);
  }

  static String buildNotificationsCacheKey(String uid) {
    return 'notification:$uid';
  }
}
