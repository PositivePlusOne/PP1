// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';

class PositiveSwitchProfileDialog extends HookConsumerWidget {
  const PositiveSwitchProfileDialog({
    required this.controller,
    super.key,
  });

  final ProfileSwitchMixin controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final String currentUserId = profileController.currentUserId ?? '';
    final String currentProfileId = controller.getCurrentProfileId();
    final Set<String> availableProfileIds = profileController.state.availableProfileIds;

    // Get a new set with the current profile id first
    final List<String> profileIds = <String>{currentUserId, ...availableProfileIds}.toList();
    final List<Profile> profiles = cacheController.list(profileIds);

    return Column(
      children: <Widget>[
        ...profiles
            .map(
              (Profile profile) {
                final bool isCurrentUser = profile.flMeta?.id == currentUserId;
                final int index = profiles.indexOf(profile);

                String label = isCurrentUser ? 'Yourself' : profile.displayName;
                if (label.isEmpty) {
                  label = isCurrentUser ? 'Yourself' : 'Unknown';
                }

                return PositiveButton(
                  icon: isCurrentUser ? UniconsLine.user_circle : UniconsLine.building,
                  label: label,
                  colors: colors,
                  isDisabled: currentProfileId == profile.flMeta?.id,
                  primaryColor: index % 2 == 0 ? colors.black : colors.white,
                  onTapped: () => Navigator.of(context).pop(profile.flMeta?.id),
                );
              },
            )
            .toList()
            .spaceWithVertical(kPaddingSmall),
      ],
    );
  }
}
