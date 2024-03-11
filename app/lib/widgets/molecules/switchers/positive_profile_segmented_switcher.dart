// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/widgets/molecules/navigation/positive_slim_tab_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';

class PositiveProfileSegmentedSwitcher extends ConsumerWidget {
  const PositiveProfileSegmentedSwitcher({
    required this.mixin,
    this.useProfileBackgroundColours = false,
    this.isSlim = false,
    this.onTapped,
    super.key,
  });

  final ProfileSwitchMixin mixin;
  final bool isSlim;
  final Function(int)? onTapped;
  final bool useProfileBackgroundColours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final List<String> supportedProfileIds = mixin.getSupportedProfileIds();
    final List<Profile> profiles = mixin.getSupportedProfiles();
    final String currentProfileId = mixin.getCurrentProfileId();

    final Map<String, Widget> children = <String, Widget>{};
    for (int i = 0; i < supportedProfileIds.length; i++) {
      final String profileId = supportedProfileIds[i];
      final Profile profile = profiles[i];
      children[profileId] = Text(profile.displayName);
    }

    switch (isSlim) {
      case true:
        return PositiveSlimTabBar(
          index: supportedProfileIds.indexOf(currentProfileId),
          onTapped: (int index) {
            mixin.switchProfile(supportedProfileIds[index]);

            if (onTapped != null) {
              onTapped!(index);
            }
          },
          tabColours: useProfileBackgroundColours ? profiles.map((Profile profile) => profile.accentColor.toSafeColorFromHex(defaultColor: colours.teal)).toList() : List<Color>.filled(profiles.length, colours.white),
          tabs: profiles.map((Profile profile) => profile.displayName).toList(),
        );
      default:
        return PositiveTabBar(
          margin: EdgeInsets.zero,
          index: supportedProfileIds.indexOf(currentProfileId),
          onTapped: (int index) => mixin.switchProfile(supportedProfileIds[index]),
          tabs: profiles.map((Profile profile) {
            final String profileId = profile.flMeta?.id ?? '';
            final bool isCurrentProfile = profileId == currentProfileId;
            final String title = isCurrentProfile ? 'Personal' : profile.displayName;

            return PositiveTabEntry(
              title: title,
              colour: profile.accentColor.toSafeColorFromHex(defaultColor: colours.teal),
            );
          }).toList(),
        );
    }
  }
}
