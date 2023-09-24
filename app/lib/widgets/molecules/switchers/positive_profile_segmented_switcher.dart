import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositiveProfileSegmentedSwitcher extends ConsumerWidget {
  const PositiveProfileSegmentedSwitcher({
    required this.mixin,
    super.key,
  });

  final ProfileSwitchMixin mixin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final List<String> supportedProfileIds = mixin.getSupportedProfileIds();
    final List<Profile> profiles = mixin.getSupportedProfiles();
    final String currentProfileId = mixin.getCurrentProfileId();

    final Map<String, Widget> children = <String, Widget>{};
    for (int i = 0; i < supportedProfileIds.length; i++) {
      final String profileId = supportedProfileIds[i];
      final Profile profile = profiles[i];
      children[profileId] = Text(profile.displayName);
    }

    return PositiveTabBar(
      margin: EdgeInsets.zero,
      index: supportedProfileIds.indexOf(currentProfileId),
      onTapped: (int index) => mixin.switchProfile(supportedProfileIds[index]),
      tabColours: profiles.map((Profile profile) => profile.accentColor.toSafeColorFromHex(defaultColor: colors.teal)).toList(),
      tabs: profiles.map((Profile profile) => profile.displayName).toList(),
    );
  }
}
