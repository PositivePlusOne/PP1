// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
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
    this.leading,
    this.trailing = const [],
  });

  final NotificationPayload payload;
  final NotificationHandler handler;
  final Relationship? senderRelationship;
  final Profile? senderProfile;

  final Widget? leading;
  final List<Widget> trailing;
}

class PositiveNotificationTileState extends ConsumerState<PositiveNotificationTile> {
  late NotificationPresenter presenter;
  StreamSubscription<dynamic>? _payloadSubscription;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  @override
  void initState() {
    super.initState();
    setupPresenter();
    setupListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAsyncronousPresenterData();
    });
  }

  void setupListeners() {
    _payloadSubscription = presenter.handler.notificationHandlerUpdateRequestStream.listen((_) => loadAsyncronousPresenterData());
  }

  @override
  void dispose() {
    _payloadSubscription?.cancel();
    super.dispose();
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

  void setupPresenter() {
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    presenter = NotificationPresenter(
      payload: widget.notification,
      handler: notificationsController.getHandlerForPayload(widget.notification),
    );
  }

  Future<void> loadAsyncronousPresenterData() async {
    if (!mounted) {
      return;
    }

    final Logger logger = providerContainer.read(loggerProvider);
    final FirebaseAuth auth = providerContainer.read(firebaseAuthProvider);
    final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final NotificationHandler handler = presenter.handler;

    logger.i('Attemptinig to load payload related data for ${widget.notification.key}');
    if (auth.currentUser == null) {
      logger.e('User is not logged in, cannot load payload related data for ${widget.notification.key}');
      return;
    }

    Relationship? relationship;
    Profile? profile;
    final String sender = widget.notification.sender;

    if (sender.isNotEmpty) {
      final Future<Relationship> relationshipFuture = relationshipController.getRelationship([auth.currentUser!.uid, sender]);
      final Future<Profile> profileFuture = profileController.getProfile(sender);

      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[relationshipFuture, profileFuture]);
      relationship = results[0] as Relationship;
      profile = results[1] as Profile;
    }

    presenter = NotificationPresenter(
      payload: widget.notification,
      handler: handler,
      senderRelationship: relationship,
      senderProfile: profile,
    );

    if (mounted) {
      setState(() {});
    }

    logger.i('Attempting to create widgets for ${widget.notification.key}');
    final Widget leading = await handler.buildNotificationLeading(this);
    final List<Widget> trailing = await handler.buildNotificationTrailing(this);

    logger.i('Successfully created widgets for ${widget.notification.key}');
    presenter = NotificationPresenter(
      payload: widget.notification,
      handler: handler,
      senderRelationship: relationship,
      senderProfile: profile,
      leading: leading,
      trailing: trailing,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NotificationPayload payload = presenter.payload;
    final NotificationHandler handler = presenter.handler;

    final Color backgroundColor = handler.getBackgroundColor(payload);

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
          if (presenter.leading != null) ...<Widget>[
            presenter.leading!,
          ] else ...<Widget>[
            PositiveCircularIndicator(
              ringColor: backgroundColor.complimentTextColor,
              child: Icon(UniconsLine.bell, color: backgroundColor.complimentTextColor.complimentTextColor),
            ),
          ],
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: Text(
              payload.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: typography.styleNotification.copyWith(color: colors.black),
            ),
          ),
          if (presenter.trailing.isNotEmpty) ...<Widget>[
            const SizedBox(width: kPaddingExtraSmall),
            ...presenter.trailing.spaceWithHorizontal(kPaddingExtraSmall),
          ],
        ],
      ),
    );
  }
}
