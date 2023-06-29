// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/handlers/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
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
  ConsumerState<PositiveNotificationTile> createState() => _PositiveNotificationTileState();
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

class _PositiveNotificationTileState extends ConsumerState<PositiveNotificationTile> {
  late final NotificationHandler handler;

  final StreamController<NotificationPresenter> _notificationStreamController = StreamController<NotificationPresenter>.broadcast();
  Stream<NotificationPresenter> get notificationStream => _notificationStreamController.stream;

  @override
  void initState() {
    super.initState();
    setupHandler();
    setInitialPayload();
    loadPayloadRelatedData();
  }

  void setupHandler() {
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    handler = notificationsController.getHandlerForPayload(widget.notification);
  }

  void setInitialPayload() {
    _notificationStreamController.add(NotificationPresenter(
      payload: widget.notification,
      handler: handler,
    ));
  }

  Future<void> loadPayloadRelatedData() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.i('Attemptinig to load payload related data for ${widget.notification.key}');
    if (auth.currentUser == null) {
      logger.e('User is not logged in, cannot load payload related data for ${widget.notification.key}');
      return;
    }

    final String sender = widget.notification.sender;
    if (sender.isEmpty) {
      logger.e('Sender is empty, cannot load payload related data for ${widget.notification.key}');
      return;
    }

    final Future<Relationship> relationshipFuture = relationshipController.getRelationship([auth.currentUser!.uid, sender]);
    final Future<Profile> profileFuture = profileController.getProfile(sender);

    final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[relationshipFuture, profileFuture]);
    final Relationship relationship = results[0] as Relationship;
    final Profile profile = results[1] as Profile;

    logger.i('Attempting to create widgets for ${widget.notification.key}');
    final Future<Widget> leadingFuture = handler.buildNotificationLeading(widget.notification, profile, relationship);
    final Future<List<Widget>> trailingFuture = handler.buildNotificationTrailing(widget.notification, profile, relationship);

    final List<dynamic> widgets = await Future.wait<dynamic>(<Future<dynamic>>[leadingFuture, trailingFuture]);
    final Widget? leading = widgets[0] as Widget?;
    final List<Widget> trailing = widgets[1] as List<Widget>;

    logger.i('Successfully created widgets for ${widget.notification.key}');

    _notificationStreamController.add(NotificationPresenter(
      payload: widget.notification,
      handler: handler,
      senderRelationship: relationship,
      senderProfile: profile,
      leading: leading,
      trailing: trailing,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NotificationPresenter>(
      stream: notificationStream,
      builder: buildNotificationWidget,
    );
  }

  Widget buildNotificationWidget(BuildContext context, AsyncSnapshot<NotificationPresenter> snapshot) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    // This should not happen, but if it does, we don't want to crash the app
    if (snapshot.data == null) {
      return const SizedBox();
    }

    final NotificationPayload payload = snapshot.data!.payload;
    final NotificationHandler handler = snapshot.data!.handler;
    final NotificationPresenter presenter = snapshot.data!;

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
            const SizedBox(width: kPaddingSmall),
            ...presenter.trailing,
          ],
        ],
      ),
    );
  }
}
