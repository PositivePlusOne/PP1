// Flutter imports:
import 'package:app/providers/user/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import 'components/hub_app_bar_content.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider.notifier);
    final UserControllerState userControllerState = ref.watch(userControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final String referenceImage = ref.watch(profileControllerProvider.select((value) => value.userProfile?.referenceImage ?? ''));

    useLifecycleHook(viewModel);

    final bool shouldDisplayActivateAccountBanner = userControllerState.user == null;

    return PositiveScaffold(
      onRefresh: viewModel.onRefresh,
      refreshController: viewModel.refreshController,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: 0,
      ),
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        foregroundColor: colors.black,
        backgroundColor: colors.pink,
        bottom: HubAppBarContent(
          shouldDisplayActivateAccountBanner: shouldDisplayActivateAccountBanner,
        ),
        trailType: PositiveAppBarTrailType.convex,
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: viewModel.onNotificationsSelected,
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            onTapped: viewModel.onAccountSelected,
          ),
        ],
      ),
      headingWidgets: <Widget>[
        if (referenceImage.isNotEmpty) ...<Widget>[
          SliverToBoxAdapter(
            child: Image.network(referenceImage),
          ),
        ],
      ],
    );
  }
}
