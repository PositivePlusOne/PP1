// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../../providers/system/design_controller.dart';

class PositiveNotificationTile extends StatefulHookConsumerWidget {
  const PositiveNotificationTile({
    required this.notification,
    this.isEnabled = true,
    this.onNotificationSelected,
    super.key,
  });

  final NotificationPayload notification;

  final bool isEnabled;
  final FutureOr<void> Function(BuildContext context, NotificationPayload payload)? onNotificationSelected;

  static const double kConstrainedHeight = 62.0;

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

    if (widget.notification.userId.isNotEmpty && widget.notification.sender.isNotEmpty) {
      senderRelationship = cacheController.getFromCache([widget.notification.sender, widget.notification.userId].asGUID);
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
    final logger = ref.read(loggerProvider);
    final String senderStr = widget.notification.sender;
    final String receiverStr = widget.notification.userId;
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
    final logger = ref.read(loggerProvider);
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final NotificationPayload payload = presenter.payload;
    final NotificationHandler handler = presenter.handler;
    final bool includeTimestamp = handler.includeTimestampOnFeed(payload);

    final Color backgroundColor = handler.getBackgroundColor(payload);
    final Color foregroundColor = handler.getForegroundColor(payload);

    final Widget leading = handler.buildNotificationLeading(this);
    final List<Widget> trailing = handler.buildNotificationTrailing(this);

    // Once we're live and have more time, we need to find a nice way to localize this
    // As when we go to the African market, this might go haywire.
    String body = payload.body;
    if (includeTimestamp && payload.createdAt != null) {
      try {
        // Remove full stop from end of body if it exists
        if (body.endsWith('.')) {
          body = body.substring(0, body.length - 1);
        }

        final Jiffy createdAt = Jiffy.parse(payload.createdAt!);
        final String timeAgo = createdAt.fromNow();
        body = '$body $timeAgo.';
      } catch (ex) {
        logger.e('Failed to parse createdAt: ${payload.createdAt} - ex: $ex');
      }
    }

    return PositiveTapBehaviour(
      onTap: (context) => widget.onNotificationSelected?.call(context, payload),
      isEnabled: widget.isEnabled,
      showDisabledState: !widget.isEnabled,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        constraints: const BoxConstraints(
          minHeight: PositiveNotificationTile.kConstrainedHeight,
          maxHeight: PositiveNotificationTile.kConstrainedHeight,
        ),
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
              child: IgnorePointer(
                ignoring: true,
                child: buildMarkdownWidgetFromBody(
                  body,
                  lineMargin: const EdgeInsets.symmetric(vertical: kPaddingSuperSmall),
                  onTapLink: (_) {},
                ),
              ),
            ),
            if (trailing.isNotEmpty) ...<Widget>[
              const SizedBox(width: kPaddingExtraSmall),
              ...trailing.spaceWithHorizontal(kPaddingExtraSmall),
            ],
          ],
        ),
      ),
    );
  }
}
