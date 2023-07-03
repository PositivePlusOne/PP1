// Dart imports:

// Flutter imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/notifications/components/positive_notification_tile.dart';
import 'package:app/widgets/organisms/notifications/vms/notifications_view_model.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/profile_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/system/notifications_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';

@RoutePage()
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    final List<NotificationPayload> notifications = ref.watch(notificationsControllerProvider.select((value) => value.notifications.values.toList()));

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final List<Widget> actions = [];
    if (profileState.userProfile != null) {
      actions.addAll(profileState.userProfile!.buildCommonProfilePageActions(disableNotifications: true));
    }

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
            for (final NotificationPayload payload in notifications) ...<Widget>[
              Dismissible(
                key: ValueKey<String>('notification-${payload.key}'),
                onDismissed: (_) => viewModel.onNotificationDismissed(payload),
                child: PositiveTileEntryAnimation(
                  child: PositiveNotificationTile(notification: payload),
                ),
              ),
            ],
          ].spaceWithVertical(kPaddingSmall),
        ),
      ],
    );
  }
}
