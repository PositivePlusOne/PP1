// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/providers/system/handlers/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
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
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/organisms/notifications/vms/notifications_view_model.dart';
import '../../../../providers/events/connections/relationship_updated_event.dart';
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
  });

  final NotificationPayload payload;
  final NotificationHandler handler;
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
    loadPayloadDeterministicData();
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

  Future<void> loadPayloadDeterministicData() async {
    // TODO
    dsf
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

    if (snapshot.data == null) {
      // We can probably show them a version without the payload extra data
      return const SizedBox();
    }

    final NotificationPayload payload = snapshot.data!.payload;
    final NotificationHandler handler = snapshot.data!.handler;

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
          PositiveCircularIndicator(
            ringColor: backgroundColor.complimentTextColor,
            child: Icon(UniconsLine.bell, color: backgroundColor.complimentTextColor.complimentTextColor),
          ),
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: Text(
              payload.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: typography.styleNotification.copyWith(color: colors.black),
            ),
          ),
          // if (actions.isNotEmpty) ...<Widget>[
          //   const SizedBox(width: kPaddingSmall),
          //   ...actions.spaceWithHorizontal(kPaddingExtraSmall),
          // ],
          // if (actions.isEmpty) ...<Widget>[
          //   const SizedBox(width: kPaddingSmall),
          // ],
        ],
      ),
    );
  }
}
