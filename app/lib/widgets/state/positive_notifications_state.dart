// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/widgets/state/positive_pagination_controller_state.dart';

class PositiveNotificationsState with PositivePaginationControllerState {
  PositiveNotificationsState({
    required this.pagingController,
    required this.uid,
    required this.currentPaginationKey,
    required this.unreadCount,
    required this.unseenCount,
    required this.hasFirstLoad,
  });

  @override
  final PagingController<String, NotificationPayload> pagingController;

  final String uid;

  String currentPaginationKey;
  int unreadCount;
  int unseenCount;
  bool hasFirstLoad;

  @override
  String buildCacheKey() {
    return buildNotificationsCacheKey(uid);
  }

  static String buildNotificationsCacheKey(String uid) {
    return 'notification:$uid';
  }
}
