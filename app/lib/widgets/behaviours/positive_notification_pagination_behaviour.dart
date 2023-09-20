// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/pagination_constants.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/notification_api_service.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';
import 'package:app/widgets/state/positive_notifications_state.dart';
import '../../services/third_party.dart';

class PositiveNotificationsPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveNotificationsPaginationBehaviour({
    required this.uid,
    this.windowSize = kStandardFeedWindowSize,
    this.onPageLoaded,
    super.key,
  });

  final String uid;
  final int windowSize;
  final Function(Map<String, dynamic>)? onPageLoaded;

  static const String kWidgetKey = 'PositiveNotificationsPaginationBehaviour';

  @override
  ConsumerState<PositiveNotificationsPaginationBehaviour> createState() => PositiveNotificationsPaginationBehaviourState();
}

class PositiveNotificationsPaginationBehaviourState extends ConsumerState<PositiveNotificationsPaginationBehaviour> {
  late PositiveNotificationsState notificationsState;

  final Map<String, bool> busyNotifications = {};

  static String getExpectedCacheKey(String uid) => 'notifications:$uid';

  @override
  void initState() {
    super.initState();
    setupNotificationsState();
  }

  @override
  void dispose() {
    disposeNotificationsState();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveNotificationsPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      disposeNotificationsState();
      setupNotificationsState();
    }
  }

  bool isNotificationEnabled(NotificationPayload notification) {
    return busyNotifications.containsKey(notification.id) ? !busyNotifications[notification.id]! : true;
  }

  void disposeNotificationsState() {
    notificationsState.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupNotificationsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('setupNotificationsState() - Loading state for ${widget.uid}');
    final PositiveNotificationsState? cachedFeedState = cacheController.getFromCache(getExpectedCacheKey(widget.uid));
    if (cachedFeedState != null) {
      logger.d('setupNotificationsState() - Found cached state for ${widget.uid}');
      notificationsState = cachedFeedState;
      notificationsState.pagingController.addPageRequestListener(requestNextPage);
      return;
    }

    logger.d('setupNotificationsState() - No cached state for ${widget.uid}. Creating new state.');
    final PagingController<String, NotificationPayload> pagingController = PagingController<String, NotificationPayload>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    notificationsState = PositiveNotificationsState(
      uid: widget.uid,
      pagingController: pagingController,
      currentPaginationKey: '',
      unreadCount: 0,
      unseenCount: 0,
    );
  }

  void saveNotificationsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('saveState() - Saving notifications state for ${widget.uid}');
    cacheController.addToCache(key: getExpectedCacheKey(widget.uid), value: notificationsState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final NotificationApiService notificationApiService = await providerContainer.read(notificationApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await notificationApiService.listNotifications(
        cursor: notificationsState.currentPaginationKey,
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String next = data.containsKey('cursor') ? data['cursor'].toString() : '';

      if (data.containsKey('unread_count') && data['unread_count'] is int) {
        logger.d('requestNextTimelinePage() - unread_count: ${data['unread_count']}');
        notificationsState.unreadCount = data['unread_count'] as int;
      }

      if (data.containsKey('unseen_count') && data['unseen_count'] is int) {
        logger.d('requestNextTimelinePage() - unseen_count: ${data['unseen_count']}');
        notificationsState.unseenCount = data['unseen_count'] as int;
      }

      // Check for weird backend loops (extra safety)
      if (next == notificationsState.currentPaginationKey) {
        next = '';
      }

      appendNotificationsPage(data, next);
      widget.onPageLoaded?.call(data);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      notificationsState.pagingController.error = ex;
    } finally {
      saveNotificationsState();
    }
  }

  void appendNotificationsPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != notificationsState.currentPaginationKey;

    notificationsState.currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: ${notificationsState.currentPaginationKey}');

    final List<NotificationPayload> newNotifications = [];
    final List<dynamic> notifications = (data.containsKey('notifications') ? data['notifications'] : []).map((dynamic activity) => json.decodeSafe(activity)).toList();

    for (final dynamic notification in notifications) {
      try {
        logger.d('requestNextTimelinePage() - parsing notification: $notification');
        final NotificationPayload newNotification = NotificationPayload.fromJson(notification);
        if (newNotification.id.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse notification: $notification');
          continue;
        }

        newNotifications.add(newNotification);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse notification: $notification - ex: $ex');
      }
    }

    logger.d('requestNextTimelinePage() - newNotifications: $newNotifications');

    if (!hasNext && mounted) {
      notificationsState.pagingController.appendSafeLastPage(newNotifications);
    } else if (mounted) {
      notificationsState.pagingController.appendSafePage(newNotifications, nextPageKey);
    }

    saveNotificationsState();
  }

  FutureOr<void> onNotificationSelected(BuildContext context, NotificationPayload payload) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    logger.i('onNotificationSelected() - payload: $payload');

    if (payload.id.isEmpty) {
      logger.e('onNotificationSelected() - Invalid notification payload: $payload');
      return;
    }

    if (busyNotifications.containsKey(payload.id)) {
      logger.d('onNotificationSelected() - Notification is already being processed: $payload');
      return;
    }

    busyNotifications[payload.id] = true;
    setStateIfMounted();

    try {
      final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);
      await handler.onNotificationSelected(payload, context);
    } finally {
      busyNotifications.remove(payload.id);
      setStateIfMounted();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = Align(alignment: Alignment.center, child: PositiveLoadingIndicator());
    return PagedSliverList.separated(
      pagingController: notificationsState.pagingController,
      separatorBuilder: (_, __) => const SizedBox(height: kPaddingSmall),
      builderDelegate: PagedChildBuilderDelegate<NotificationPayload>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        itemBuilder: (_, notification, __) {
          return PositiveNotificationTile(
            notification: notification,
            isEnabled: isNotificationEnabled(notification),
            onNotificationSelected: onNotificationSelected,
          );
        },
        firstPageErrorIndicatorBuilder: (context) => const SizedBox(),
        newPageErrorIndicatorBuilder: (context) => const SizedBox(),
        noMoreItemsIndicatorBuilder: (context) => const SizedBox(),
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }
}
