import 'dart:async';

import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/services/third_party.dart';
import 'package:event_bus/event_bus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

class PositiveFeedState {
  PositiveFeedState({
    required this.feed,
    required this.slug,
    required this.pagingController,
    required this.currentPaginationKey,
  });

  final String feed;
  final String slug;
  final PagingController<String, Activity> pagingController;
  String currentPaginationKey;

  StreamSubscription<ActivityCreatedEvent>? activityCreatedSubscription;
  StreamSubscription<ActivityUpdatedEvent>? activityUpdatedSubscription;
  StreamSubscription<ActivityDeletedEvent>? activityDeletedSubscription;

  void setupListeners() {
    final Logger logger = providerContainer.read(loggerProvider);
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    activityCreatedSubscription = eventBus.on<ActivityCreatedEvent>().listen((ActivityCreatedEvent event) {
      if (event.feed != feed || event.slug != slug) {
        return;
      }

      logger.d('ActivityCreatedEvent - feed: ${event.feed} - slug: ${event.slug} - activity: ${event.activity}');
      pagingController.itemList?.add(event.activity);
    });

    activityUpdatedSubscription = eventBus.on<ActivityUpdatedEvent>().listen((ActivityUpdatedEvent event) {
      if (event.feed != feed || event.slug != slug) {
        return;
      }

      logger.d('ActivityUpdatedEvent - feed: ${event.feed} - slug: ${event.slug} - activity: ${event.activity}');
      final int index = pagingController.itemList?.indexWhere((Activity activity) => activity.flMeta?.id == event.activity.flMeta?.id) ?? -1;
      if (index >= 0) {
        pagingController.itemList?[index] = event.activity;
      }
    });

    activityDeletedSubscription = eventBus.on<ActivityDeletedEvent>().listen((ActivityDeletedEvent event) {
      if (event.feed != feed || event.slug != slug) {
        return;
      }

      logger.d('ActivityDeletedEvent - feed: ${event.feed} - slug: ${event.slug} - activity: ${event.activity}');
      final int index = pagingController.itemList?.indexWhere((Activity activity) => activity.flMeta?.id == event.activity.flMeta?.id) ?? -1;
      if (index >= 0) {
        pagingController.itemList?.removeAt(index);
      }
    });
  }

  Future<void> dispose() async {
    await activityCreatedSubscription?.cancel();
    await activityUpdatedSubscription?.cancel();
    await activityDeletedSubscription?.cancel();
  }
}
