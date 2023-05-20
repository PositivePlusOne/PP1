// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/user_notification.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/notifications/vms/notifications_view_model.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/profile_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/system/notifications_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_circular_indicator.dart';
import '../../molecules/navigation/positive_app_bar.dart';

@RoutePage()
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    final List<UserNotification> notifications = ref.watch(notificationsControllerProvider.select((value) => value.notifications.values.toList()));

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final List<Widget> actions = [
      PositiveButton.appBarIcon(
        colors: colors,
        icon: UniconsLine.bell,
        onTapped: () {},
        isDisabled: true,
      ),
      PositiveButton.appBarIcon(
        colors: colors,
        icon: UniconsLine.user,
        onTapped: () => onProfileAccountActionSelected(shouldReplace: true),
      ),
    ];

    return PositiveScaffold(
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        foregroundColor: colors.black,
        trailing: actions,
      ),
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            for (final UserNotification notification in notifications) ...<Widget>[
              Dismissible(
                key: ValueKey<String>('notification-${notification.key}'),
                onDismissed: (_) => viewModel.onNotificationDismissed(notification),
                child: PositiveNotificationTile(
                  notification: notification,
                ),
              ),
            ],
          ].spaceWithVertical(kPaddingSmall),
        ),
      ],
    );
  }
}

class PositiveNotificationTile extends ConsumerWidget {
  const PositiveNotificationTile({
    super.key,
    required this.notification,
  });

  final UserNotification notification;

  static const double kMinimumHeight = 62.0;

  Color getBackgroundColor(DesignColorsModel colors) {
    try {
      switch (notification.action) {
        case 'ACTION_CONNECTION_REQUEST_RECEIVED':
          return colors.purple;
        default:
          break;
      }
    } catch (_) {}

    return colors.white;
  }

  List<Widget> buildActions(BuildContext context, NotificationsViewModel vm, NotificationsViewModelState state, DesignColorsModel colors, Color backgroundColor) {
    final List<Widget> actions = <Widget>[];
    try {
      final Map<String, dynamic> payload = json.decode(notification.payload) as Map<String, dynamic>;
      switch (notification.action) {
        case 'ACTION_CONNECTION_REQUEST_RECEIVED':
          final String sender = payload['sender'] as String;
          actions.addAll(buildAcceptConnectionRequestActions(vm, state, colors, backgroundColor, sender));
          break;
        default:
          break;
      }
    } catch (_) {}

    return actions;
  }

  List<Widget> buildAcceptConnectionRequestActions(NotificationsViewModel vm, NotificationsViewModelState state, DesignColorsModel colors, Color backgroundColor, String sender) {
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
          dismissKey: notification.key,
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
          dismissKey: notification.key,
        ),
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    final NotificationsViewModelState state = ref.watch(notificationsViewModelProvider);

    final Color backgroundColor = getBackgroundColor(colors);
    final List<Widget> actions = buildActions(context, viewModel, state, colors, backgroundColor);

    return Container(
      padding: const EdgeInsets.all(kPaddingSmall),
      constraints: const BoxConstraints(minHeight: kMinimumHeight),
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
              notification.body,
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
