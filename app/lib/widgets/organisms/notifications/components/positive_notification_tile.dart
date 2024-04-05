// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

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

  static const int kMaxBodyLength = 60;

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

  @override
  void didUpdateWidget(PositiveNotificationTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.notification.id != widget.notification.id) {
      reloadPresenter();
    }
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
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final NotificationHandler handler = notificationsController.getHandlerForPayload(widget.notification);

    Relationship? senderRelationship;
    final Profile? senderProfile = cacheController.get(widget.notification.sender);

    if (widget.notification.userId.isNotEmpty && widget.notification.sender.isNotEmpty) {
      senderRelationship = cacheController.get([widget.notification.sender, widget.notification.userId].asGUID);
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

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final NotificationPayload payload = presenter.payload;
    final NotificationHandler handler = presenter.handler;
    final bool includeTimestamp = handler.includeTimestampOnFeed(payload);

    Widget leading = handler.buildNotificationLeading(this);
    final List<Widget> trailing = handler.buildNotificationTrailing(this);

    // Once we're live and have more time, we need to find a nice way to localize this
    // As when we go to the African market, this might go haywire.
    String body = payload.bodyMarkdown.isEmpty ? payload.body : payload.bodyMarkdown;

    //? Truncate body
    if (body.length >= PositiveNotificationTile.kMaxBodyLength) {
      body = "${body.substring(0, PositiveNotificationTile.kMaxBodyLength)}...";
    }

    //? Repair double @'s if they occur
    RegExp exp = RegExp(r'\@\@');
    List<RegExpMatch> matches = exp.allMatches(body).toList();
    for (var i = matches.length - 1; i >= 0; i--) {
      body = body.replaceRange(matches[i].start, matches[i].end, '@');
    }

    //? Repair broken bold markings
    exp = RegExp(r'\*\*');
    matches = exp.allMatches(body).toList();
    int matchesFound = matches.length;

    if (matchesFound.isOdd) {
      if (body[body.length - 1] == '*') {
        body = "$body*";
      } else {
        body = "$body**";
      }
    }

    if (includeTimestamp && payload.createdAt != null) {
      try {
        // Remove full stop from end of body if it exists\*\*
        if (body.endsWith('.')) {
          body = body.substring(0, body.length - 1);
        }

        // let's parse the time as a standard ISO string
        final timeAgo = payload.createdAt!.asDateDifference(context);
        body = '$body ${timeAgo.toLowerCase()}.';
      } catch (ex) {
        logger.e('Failed to parse createdAt: ${payload.createdAt} - ex: $ex');
      }
    }

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (currentProfile != null) {
      final Set<RelationshipState> relationshipStates = presenter.senderRelationship?.relationshipStatesForEntity(currentProfileId) ?? {};
      final bool isTargetBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
      if (isTargetBlocked) {
        leading = const PositiveProfileCircularIndicator();
      }

      // Replace all instances of the sender's display name with a generic "Someone"
      final String senderDisplayName = presenter.senderProfile?.displayName.asHandle ?? '';
      if (senderDisplayName.isNotEmpty && isTargetBlocked) {
        body = body.replaceAll(senderDisplayName, localizations.shared_placeholders_empty_display_name);
      }
    }

    return PositiveTapBehaviour(
      onTap: (context) => widget.onNotificationSelected?.call(context, payload),
      isEnabled: widget.isEnabled,
      showDisabledState: !widget.isEnabled,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
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
                  brightness: Brightness.light,
                  lineMargin: const EdgeInsets.symmetric(vertical: kPaddingSuperSmall),
                  onTapLink: (_) {},
                  squashParagraphs: true,
                  boldHandles: false,
                ),
              ),
            ),
            if (trailing.isNotEmpty) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
              ...trailing.spaceWithHorizontal(kPaddingExtraSmall),
            ],
          ],
        ),
      ),
    );
  }
}
