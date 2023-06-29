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
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

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
        style: PositiveButtonStyle.outline,
        onTapped: () => onResendTestNotification(state),
      ),
    ];
  }

  Future<void> onResendTestNotification(PositiveNotificationTileState state) async {
    await state.handleOperation(() async {
      final DevelopmentViewModel developmentViewModel = providerContainer.read(developmentViewModelProvider.notifier);
      await developmentViewModel.sentTestNotification();
    });

    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    notificationsController.dismissNotification(state.presenter.payload.key);
  }
}
