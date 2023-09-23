// Dart imports:

// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';

class PositiveNotificationsState {
  PositiveNotificationsState({
    required this.uid,
    required this.pagingController,
    required this.currentPaginationKey,
    required this.unreadCount,
    required this.unseenCount,
    required this.hasFirstLoad,
  });

  final String uid;
  final PagingController<String, NotificationPayload> pagingController;
  String currentPaginationKey;
  int unreadCount;
  int unseenCount;
  bool hasFirstLoad;
}
