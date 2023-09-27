// Flutter imports:
import 'package:app/widgets/molecules/switchers/positive_profile_segmented_switcher.dart';
import 'package:app/widgets/organisms/account/vms/account_page_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../helpers/profile_helpers.dart';
import '../../atoms/buttons/positive_button.dart';
import 'components/account_options_pane.dart';
import 'components/account_profile_banner.dart';

@RoutePage()
class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileControllerProvider);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountPageViewModel viewModel = ref.watch(accountPageViewModelProvider.notifier);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final List<Widget> actions = [
      PositiveButton.appBarIcon(
        colors: colors,
        icon: UniconsLine.bell,
        onTapped: () => onProfileNotificationsActionSelected(shouldReplace: true),
      ),
      PositiveButton.appBarIcon(
        colors: colors,
        icon: UniconsLine.user,
        onTapped: () {},
        isDisabled: true,
      ),
    ];

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: colors.black,
          backgroundColor: colors.teal,
          appBarTrailing: actions,
          appBarTrailType: PositiveAppBarTrailType.convex,
          appBarBottom: PreferredSize(
            preferredSize: const Size(double.infinity, AccountProfileBanner.kBannerHeight + kPaddingMedium + kPaddingSmall * 2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPaddingSmall, horizontal: kPaddingMedium),
                  child: PositiveProfileSegmentedSwitcher(mixin: viewModel),
                ),
                const AccountProfileBanner(),
              ],
            ),
          ),
          appBarSpacing: kPaddingMedium,
          horizontalPadding: kPaddingSmall,
          children: <Widget>[
            AccountOptionsPane(colors: colors),
            //! PP1-984
            // const SizedBox(height: kPaddingMedium),
            // PremiumMembershipBanner(colors: colors, typography: typography),
          ],
        ),
      ],
    );
  }
}
