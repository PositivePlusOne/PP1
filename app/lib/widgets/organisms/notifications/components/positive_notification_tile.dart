// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
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
    super.key,
    required this.notification,
  });

  final UserNotification notification;

  static const double kMinimumHeight = 62.0;

  @override
  ConsumerState<PositiveNotificationTile> createState() => _PositiveNotificationTileState();
}

class _PositiveNotificationTileState extends ConsumerState<PositiveNotificationTile> {
  late final StreamSubscription<RelationshipUpdatedEvent> _relationshipsUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    _relationshipsUpdatedSubscription.cancel();
    super.dispose();
  }

  void setupListeners() {
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    _relationshipsUpdatedSubscription = relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsUpdated);
  }

  void onRelationshipsUpdated(RelationshipUpdatedEvent event) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[NotificationsPage] onRelationshipsUpdated()');

    if (mounted) {
      setState(() {});
    }
  }

  Color getBackgroundColor(DesignColorsModel colors) {
    try {
      switch (widget.notification.topic) {
        case 'TOPIC_CONNECTIONS':
          return colors.purple;
        default:
          break;
      }
    } catch (_) {}

    return colors.white;
  }

  List<Widget> buildActions(
    BuildContext context,
    NotificationsViewModel vm,
    NotificationsViewModelState state,
    RelationshipController relationshipController,
    DesignColorsModel colors,
    Color backgroundColor,
  ) {
    final List<Widget> actions = <Widget>[];
    try {
      final Map<String, dynamic> payload = json.decodeSafe(widget.notification.payload);
      final String sender = payload['sender'] as String;
      final bool hasPendingConnectionRequest = relationshipController.hasPendingConnectionRequestToCurrentUser(sender);

      switch (widget.notification.topic) {
        case 'TOPIC_CONNECTIONS':
          if (hasPendingConnectionRequest) {
            actions.addAll(buildAcceptConnectionRequestActions(vm, state, relationshipController, colors, backgroundColor, sender));
          }
          break;
        default:
          break;
      }
    } catch (_) {}

    return actions;
  }

  List<Widget> buildAcceptConnectionRequestActions(
    NotificationsViewModel vm,
    NotificationsViewModelState state,
    RelationshipController relationshipController,
    DesignColorsModel colors,
    Color backgroundColor,
    String sender,
  ) {
    final List<Widget> actions = <Widget>[];

    actions.add(
      PositiveButton(
        colors: colors,
        primaryColor: backgroundColor.complimentTextColor,
        style: PositiveButtonStyle.outline,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        icon: UniconsLine.times,
        isDisabled: state.isBusy,
        onTapped: () => vm.performNotificationAction(
          (ref) => ref.read(relationshipControllerProvider.notifier).disconnectRelationship(sender),
          dismissKey: widget.notification.key,
        ),
      ),
    );

    actions.add(
      PositiveButton(
        colors: colors,
        primaryColor: backgroundColor.complimentTextColor,
        style: PositiveButtonStyle.primary,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        icon: UniconsLine.check,
        isDisabled: state.isBusy,
        onTapped: () => vm.performNotificationAction(
          (ref) => ref.read(relationshipControllerProvider.notifier).connectRelationship(sender),
          dismissKey: widget.notification.key,
        ),
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    final NotificationsViewModelState state = ref.watch(notificationsViewModelProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);

    final Color backgroundColor = getBackgroundColor(colors);
    final List<Widget> actions = buildActions(context, viewModel, state, relationshipController, colors, backgroundColor);

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
              widget.notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: typography.styleNotification.copyWith(color: colors.black),
            ),
          ),
          if (actions.isNotEmpty) ...<Widget>[
            const SizedBox(width: kPaddingSmall),
            ...actions.spaceWithHorizontal(kPaddingExtraSmall),
          ],
          if (actions.isEmpty) ...<Widget>[
            const SizedBox(width: kPaddingSmall),
          ],
        ],
      ),
    );
  }
}
