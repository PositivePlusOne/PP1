// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';

class PositiveNotificationsButton extends ConsumerWidget {
  const PositiveNotificationsButton({
    this.color,
    super.key,
  });

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final NotificationsControllerState notificationsState = ref.watch(notificationsControllerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final bool includeBadge = notificationsState.notifications.isNotEmpty;

    // If the route is the notifications route, then we want to disable the notifications button
    final bool disableNotifications = router.current.name == NotificationsRoute.name;

    return PositiveButton.appBarIcon(
      icon: UniconsLine.bell,
      colors: colors,
      primaryColor: color ?? colors.black,
      onTapped: () => router.push(const NotificationsRoute()),
      isDisabled: disableNotifications,
      includeBadge: includeBadge,
    );
  }
}
