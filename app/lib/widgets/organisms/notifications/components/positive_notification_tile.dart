// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import '../../../../providers/system/design_controller.dart';

class PositiveNotificationTile extends StatefulHookConsumerWidget {
  const PositiveNotificationTile({
    required this.notification,
    super.key,
  });

  final NotificationPayload notification;

  static const double kMinimumHeight = 62.0;

  @override
  ConsumerState<PositiveNotificationTile> createState() => PositiveNotificationTileState();
}

class NotificationPresenter {
  NotificationPresenter({
    required this.payload,
    required this.handler,
    this.senderRelationship,
    this.senderProfile,
  });

  final NotificationPayload payload;
  final NotificationHandler handler;
  final Relationship? senderRelationship;
  final Profile? senderProfile;
}

class PositiveNotificationTileState extends ConsumerState<PositiveNotificationTile> {
  late NotificationPresenter presenter;
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  @override
  void initState() {
    super.initState();
    reloadPresenter();
    setupListeners();
  }

  void setupListeners() {
    final EventBus eventBus = ref.read(eventBusProvider);
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  @override
  void dispose() {
    _cacheKeyUpdatedSubscription?.cancel();
    super.dispose();
  }

  void reloadPresenter() {
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final NotificationHandler handler = notificationsController.getHandlerForPayload(widget.notification);

    Relationship? senderRelationship;
    final Profile? senderProfile = cacheController.getFromCache(widget.notification.sender);

    if (widget.notification.sender.isNotEmpty && widget.notification.receiver.isNotEmpty) {
      senderRelationship = cacheController.getFromCache([widget.notification.sender, widget.notification.receiver].asGUID);
    }

    presenter = NotificationPresenter(
      payload: widget.notification,
      handler: handler,
      senderProfile: senderProfile,
      senderRelationship: senderRelationship,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> handleOperation(Future<void> Function() callback) async {
    if (mounted) {
      setState(() => _isBusy = true);
    }

    try {
      await callback();
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    final Logger logger = ref.read(loggerProvider);
    final String senderStr = widget.notification.sender;
    final String receiverStr = widget.notification.receiver;
    bool shouldReload = false;

    if (senderStr.isNotEmpty) {
      final bool containsSender = event.key.contains(senderStr);
      if (containsSender) {
        shouldReload = true;
      }
    }

    if (receiverStr.isNotEmpty) {
      final bool containsReceiver = event.key.contains(receiverStr);
      if (containsReceiver) {
        shouldReload = true;
      }
    }

    if (shouldReload) {
      logger.d('Reloading notification tile due to cache key update - ${widget.notification.toJson()}');
      reloadPresenter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NotificationPayload payload = presenter.payload;
    final NotificationHandler handler = presenter.handler;

    final Color backgroundColor = handler.getBackgroundColor(payload);
    final Color foregroundColor = handler.getForegroundColor(payload);

    final Widget leading = handler.buildNotificationLeading(this);
    final List<Widget> trailing = handler.buildNotificationTrailing(this);

    return Container(
      padding: const EdgeInsets.all(kPaddingSmall),
      constraints: const BoxConstraints(minHeight: PositiveNotificationTile.kMinimumHeight),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kBorderRadiusMassive),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leading,
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: AutoSizeText(
              payload.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: typography.styleNotification.copyWith(color: foregroundColor),
            ),
          ),
          if (trailing.isNotEmpty) ...<Widget>[
            const SizedBox(width: kPaddingExtraSmall),
            ...trailing.spaceWithHorizontal(kPaddingExtraSmall),
          ],
        ],
      ),
    );
  }
}
