// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../atoms/buttons/positive_button.dart';

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
        title: profileState.userProfile?.displayName ?? '',
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        backgroundColor: colors.yellow,
        foregroundColor: colors.black,
        decorationColor: colors.colorGray1,
        trailType: PositiveAppBarTrailType.concave,
        leading: PositiveButton.appBarIcon(
          colors: colors,
          icon: UniconsLine.angle_left,
          onTapped: viewModel.onBackButtonPressed,
        ),
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: () async {},
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            onTapped: () async {},
          ),
        ],
      ),
    );
  }
}
