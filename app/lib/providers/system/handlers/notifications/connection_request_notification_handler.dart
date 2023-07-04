// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';

class ConnectionRequestNotificationHandler extends NotificationHandler {
  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    return true;
  }

  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    final bool isValid = payload.action == const NotificationAction.connectionRequestReceived();
    return isValid;
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  Color getBackgroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.purple));
  }

  @override
  Future<List<Widget>> buildNotificationTrailing(PositiveNotificationTileState state) async {
    final Profile? senderProfile = state.presenter.senderProfile;
    final Relationship? senderRelationship = state.presenter.senderRelationship;
    final User? user = providerContainer.read(firebaseAuthProvider).currentUser;
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    // If we don't have the data we need, then we can't do anything.
    if (senderProfile == null || senderRelationship == null || user == null) {
      return [];
    }

    // Get the relationship states we require.
    final Set<RelationshipState> relationshipStates = senderRelationship.relationshipStatesForEntity(user.uid);
    final bool isSourceConnected = relationshipStates.contains(RelationshipState.sourceConnected);
    final bool isTargetConnected = relationshipStates.contains(RelationshipState.targetConnected);

    // If the source is already connected, then we don't need to do anything.
    // If the target is not connected, then we don't need to do anything.
    if (isSourceConnected || !isTargetConnected) {
      return [];
    }

    // Build two buttons to accept or decline the relationship.
    return [
      PositiveButton.appBarIcon(
        colors: colors,
        isDisabled: state.isBusy,
        icon: UniconsLine.multiply,
        style: PositiveButtonStyle.outline,
        onTapped: () => onDeclineRelationship(state),
      ),
      PositiveButton.appBarIcon(
        colors: colors,
        primaryColor: colors.white,
        isDisabled: state.isBusy,
        icon: UniconsLine.check,
        style: PositiveButtonStyle.primary,
        onTapped: () => onAcceptRelationship(state),
      ),
    ];
  }

  Future<void> onDeclineRelationship(PositiveNotificationTileState state) async {
    await state.handleOperation(() async {
      final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
      await relationshipController.disconnectRelationship(state.presenter.payload.sender);
    });

    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    notificationsController.dismissNotification(state.presenter.payload.key);
  }

  Future<void> onAcceptRelationship(PositiveNotificationTileState state) async {
    await state.handleOperation(() async {
      final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
      await relationshipController.connectRelationship(state.presenter.payload.sender);
    });

    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    notificationsController.dismissNotification(state.presenter.payload.key);
  }
}
