// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
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
        onTap: () {},
        ringColorOverride: colors.white,
      ),
    ];

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: foregroundColor,
          backgroundColor: profileState.currentProfile?.accentColor.toSafeColorFromHex() ?? colors.teal,
          appBarTrailing: actions,
          appBarTrailType: PositiveAppBarTrailType.convex,
          appBarBottom: PreferredSize(
            preferredSize: const Size(double.infinity, AccountProfileBanner.kBannerHeight + kPaddingMedium + kPaddingSmall * 2),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPaddingSmall, horizontal: kPaddingMedium),
                  child: PositiveProfileSegmentedSwitcher(
                    mixin: viewModel,
                    isSlim: true,
                    onTapped: (int profileIndex) => viewModel.onProfileChange(profileIndex, profileState, viewModel),
                  ),
                ),
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
                        accentColour: state.profileAccentColour,
                        mixin: viewModel,
                      ),
                      const Spacer(),
                    ],
                  ),
                  AccountOptionsPane(
                    colors: colors,
                    isOrganisation: true,
                    edgePadding: kPaddingSmall,
                    accentColour: state.organisationAccentColour,
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
