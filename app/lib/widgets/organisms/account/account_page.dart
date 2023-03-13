// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/banners/premium_membership_banner.dart';
import '../../molecules/scaffolds/positive_scaffold_decoration.dart';
import 'components/account_options_pane.dart';
import 'components/account_profile_banner.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);
    final AccountViewModel viewModel = ref.read(accountViewModelProvider.notifier);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        backgroundColor: colors.teal,
        foregroundColor: colors.black,
        trailType: PositiveAppBarTrailType.convex,
        bottom: const AccountProfileBanner(),
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: () async {},
            isDisabled: true,
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            onTapped: () async {},
            isDisabled: true,
          ),
        ],
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          horizontalPadding: kPaddingSmall,
          children: <Widget>[
            AccountOptionsPane(colors: colors),
            const SizedBox(height: kPaddingMedium),
            PremiumMembershipBanner(colors: colors, typography: typography),
          ],
        ),
      ],
    );
  }
}
