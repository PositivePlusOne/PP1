// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/switchers/positive_profile_segmented_switcher.dart';
import 'package:app/widgets/organisms/account/vms/account_page_view_model.dart';
import '../../../helpers/profile_helpers.dart';
import '../../atoms/buttons/positive_button.dart';
import 'components/account_options_pane.dart';
import 'components/account_profile_banner.dart';

@RoutePage()
class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AccountPageViewModel viewModel = ref.read(accountPageViewModelProvider.notifier);
    final AccountPageViewModelState state = ref.watch(accountPageViewModelProvider);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);
    useLifecycleHook(viewModel);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Color foregroundColor = state.profileAccentColour.impliedBrightness == Brightness.light ? Colors.black : Colors.white;

    final List<Widget> actions = [
      PositiveButton.appBarIcon(
        colors: colors,
        icon: UniconsLine.bell,
        primaryColor: foregroundColor,
        onTapped: () => onProfileNotificationsActionSelected(shouldReplace: true),
      ),
      PositiveProfileCircularIndicator(
        profile: profileController.currentProfile,
        ringColorOverride: colors.white,
        onTap: () {},
      ),
    ];

    double bannerHeight = AccountProfileBanner.kBannerHeight + kPaddingMedium + kPaddingSmall * 2;
    if (viewModel.canSwitchProfile && viewModel.availableProfileCount > 2) {
      bannerHeight += kPaddingSmall * 3;
    }

    final Size screenSize = mediaQueryData.size;
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final List<Profile> supportedProfiles = viewModel.getSupportedProfiles();

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: foregroundColor,
          backgroundColor: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow,
          appBarTrailing: actions,
          appBarTrailType: PositiveAppBarTrailType.convex,
          appBarBottom: PreferredSize(
            preferredSize: Size(double.infinity, bannerHeight),
            child: Column(
              children: <Widget>[
                // if we can switch profiles - show the profile switcher
                if (viewModel.canSwitchProfile && viewModel.availableProfileCount <= 2) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingSmall, horizontal: kPaddingMedium),
                    child: PositiveProfileSegmentedSwitcher(
                      mixin: viewModel,
                      isSlim: true,
                      onTapped: (int profileIndex) => viewModel.onProfileChange(profileIndex, profileState, viewModel),
                    ),
                  ),
                ] else if (viewModel.canSwitchProfile && viewModel.availableProfileCount > 2) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingSmall, horizontal: kPaddingMedium),
                    child: PositiveTapBehaviour(
                      isEnabled: true,
                      onTap: (context) => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                            height: screenSize.height,
                            width: screenSize.width,
                            child: PositiveCommunitiesDialog(
                              controllerProvider: communitiesControllerProvider(currentProfile: viewModel.getCurrentProfile(), currentUser: viewModel.getCurrentUser()),
                              supportedCommunityTypes: const [CommunityType.supported],
                              initialCommunityType: CommunityType.supported,
                              mode: CommunitiesDialogMode.select,
                              canCallToAction: false,
                              selectedProfiles: [profileState.currentProfile?.flMeta?.id ?? ''],
                              onProfileSelected: (String id) {
                                viewModel.switchProfile(id);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: IgnorePointer(
                          ignoring: true,
                          child: PositiveTextFieldDropdown<Profile>(
                            labelText: 'Account',
                            values: supportedProfiles,
                            initialValue: profileController.currentProfile ?? supportedProfiles.first,
                            valueStringBuilder: (value) => value.displayName,
                            placeholderStringBuilder: (value) => value.displayName,
                            onValueChanged: (type) => viewModel.switchProfile(type.flMeta?.id ?? ''),
                            backgroundColour: colours.white,
                            iconColour: colours.white,
                            iconBackgroundColour: colours.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                // always show our account banner
                const AccountProfileBanner(),
              ],
            ),
          ),
          appBarSpacing: kPaddingMedium,
          horizontalPadding: kPaddingNone,
          children: <Widget>[
            SizedBox(
              //? 7 buttons of 54 height + 6 kPaddingMedium between each button + 2 kPaddingSmallMedium for the padding inside glass pane
              height: 54 * 7 + kPaddingMedium * 6 + kPaddingSmallMedium * 2,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: viewModel.pageController,
                children: [
                  Column(
                    children: [
                      AccountOptionsPane(
                        colors: colors,
                        edgePadding: kPaddingSmall,
                        accentColour: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow,
                        mixin: viewModel,
                      ),
                      const Spacer(),
                    ],
                  ),
                  AccountOptionsPane(
                    colors: colors,
                    isOrganisation: true,
                    edgePadding: kPaddingSmall,
                    accentColour: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow,
                    mixin: viewModel,
                  ),
                ],
              ),
            ),
            //! PP1-984
            // const SizedBox(height: kPaddingMedium),
            // PremiumMembershipBanner(colors: colors, typography: typography),
          ],
        ),
      ],
    );
  }
}
