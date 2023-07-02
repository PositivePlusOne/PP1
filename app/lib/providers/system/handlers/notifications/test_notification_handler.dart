// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/development/vms/development_view_model.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';

class TestNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    return payload.action == const NotificationAction.test();
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  Future<List<Widget>> buildNotificationTrailing(PositiveNotificationTileState state) async {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return [
      PositiveButton.appBarIcon(
        colors: colors,
        isDisabled: state.isBusy,
        icon: UniconsLine.repeat,
        style: PositiveButtonStyle.ghost,
        onTapped: () => onResendTestNotification(state),
      ),
    ];
  }

  Future<void> onResendTestNotification(PositiveNotificationTileState state) async {
    await state.handleOperation(() async {
      await Future<void>.delayed(Duration(seconds: 2));

      final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
      await notificationsController.dismissNotification(state.presenter.payload.key);
    });

    final DevelopmentViewModel developmentViewModel = providerContainer.read(developmentViewModelProvider.notifier);
    await developmentViewModel.sentTestNotification();
  }
}
