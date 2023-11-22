// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
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

    final bool hasMultipleProfiles = viewModel.getSupportedProfiles().length > 1;

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Color foregroundColor = state.profileAccentColour.impliedBrightness == Brightness.light ? Colors.black : Colors.white;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final String currentUserUid = auth.currentUser?.uid ?? '';

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

    //? Banner Height
    double bannerHeight = AccountProfileBanner.kBannerHeight;
    if (hasMultipleProfiles) {
      //? size of slim account selection bar (kPaddingMedium) + small padding around account selection bar (kPaddingSmall * 2)
      //? Account selection bar is only shown if a second account is linked, and therefore only requires space for it if this is the case
      bannerHeight += kPaddingMedium + kPaddingSmall * 2;
    }
    if (viewModel.canSwitchProfile && viewModel.availableProfileCount > 2) {
      //? additional size of dropdown account selection bar (kPaddingLarge)
      //? Account selection bar is only shown if three or more accounts are linked, and therefore only requires space for it if this is the case
      bannerHeight += kPaddingLarge;
    }

    final Size preferedAppBarSize = Size(double.infinity, bannerHeight);
    final Size screenSize = mediaQueryData.size;

    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final List<Profile> supportedProfiles = viewModel.getSupportedProfiles();

    final Profile? currentProfile = profileState.currentProfile;
    final Color accentColor = profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.colorGray1;

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      backgroundColor: colors.colorGray1,
      appBarColor: accentColor,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: foregroundColor,
          backgroundColor: accentColor,
          appBarTrailing: actions,
          appBarTrailType: PositiveAppBarTrailType.convex,
          appBarBottom: PreferredSize(
            preferredSize: preferedAppBarSize,
            child: Column(
              children: <Widget>[
                if (hasMultipleProfiles && viewModel.availableProfileCount <= 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                    child: PositiveProfileSegmentedSwitcher(
                      mixin: viewModel,
                      isSlim: true,
                      onTapped: (int profileIndex) => viewModel.onProfileChange(profileIndex, viewModel),
                    ),
                  ),
                if (viewModel.canSwitchProfile && viewModel.availableProfileCount > 2) ...<Widget>[
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
                              supportedCommunityTypes: const [CommunityType.supported],
                              initialCommunityType: CommunityType.supported,
                              mode: CommunitiesDialogMode.select,
                              canCallToAction: false,
                              selectedProfiles: [profileState.currentProfile?.flMeta?.id ?? ''],
                              onProfileSelected: (String id) async {
                                Navigator.of(context).pop();
                                await Future.delayed(kAnimationDurationRegular);
                                viewModel.onProfileChange(supportedProfiles.indexWhere((element) => element.flMeta?.id == id), viewModel);
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
                            valueComparator: (oldValue, newValue) {
                              if (oldValue is! Profile || newValue is! Profile) {
                                return false;
                              }

                              return oldValue.flMeta?.id == newValue.flMeta?.id;
                            },
                            valueStringBuilder: (value) {
                              final String profileId = value.flMeta?.id ?? '';
                              if (profileId == currentUserUid) {
                                return 'Personal';
                              }

                              return value.displayName;
                            },
                            placeholderStringBuilder: (value) {
                              final String profileId = value.flMeta?.id ?? '';
                              if (profileId == currentUserUid) {
                                return 'Personal';
                              }

                              return value.displayName;
                            },
                            onValueChanged: (type) => viewModel.switchProfile(type.flMeta?.id ?? ''),
                            backgroundColour: colours.white,
                            iconColour: colours.white,
                            iconBackgroundColour: colours.black,
                            borderColour: colours.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                  child: AccountProfileBanner(profile: currentProfile),
                ),
              ],
            ),
          ),
          appBarSpacing: kPaddingMedium,
          horizontalPadding: kPaddingNone,
          children: <Widget>[
            if (currentProfile?.isOrganisation == true) ...<Widget>[
              AccountOptionsPane(
                colors: colors,
                isOrganisation: true,
                edgePadding: kPaddingSmall,
                accentColour: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow,
                mixin: viewModel,
              ),
            ] else ...<Widget>[
              AccountOptionsPane(
                colors: colors,
                edgePadding: kPaddingSmall,
                accentColour: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow,
                mixin: viewModel,
              ),
            ],
            // SizedBox(
            //   height: profileController.isCurrentlyOrganisation ? 454.0 : 380.0,
            //   child: PageView(
            //     physics: const NeverScrollableScrollPhysics(),
            //     controller: viewModel.pageController,
            //     children: <Widget>[

            //     ],
            //   ),
            // ),
            //! PP1-984
            // const SizedBox(height: kPaddingMedium),
            // PremiumMembershipBanner(colors: colors, typography: typography),
          ],
        ),
      ],
    );
  }
}
