// Flutter imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';

class PositiveNotificationsButton extends ConsumerWidget {
  const PositiveNotificationsButton({
    this.color,
    this.isDisabled = false,
    super.key,
  });

  final Color? color;
  final bool isDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AppRouter router = ref.read(appRouterProvider);

    //! TODO Get this number when we get reaction counts from get stream!
    const bool includeBadge = false;

    return PositiveButton.appBarIcon(
      icon: UniconsLine.bell,
      colors: colors,
      primaryColor: color ?? colors.black,
      onTapped: () => router.push(const NotificationsRoute()),
      isDisabled: isDisabled,
      includeBadge: includeBadge,
    );
  }
}
