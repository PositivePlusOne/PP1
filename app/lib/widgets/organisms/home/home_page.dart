// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_tab_bar.dart';
import 'components/activity_event_tile.dart';
import 'components/hub_app_bar_content.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);
    final HomeViewModelState state = ref.watch(homeViewModelProvider);

    final UserControllerState userControllerState = ref.watch(userControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingMedium),
            child: PositiveTabBar(
              index: state.currentTabIndex,
              onTapped: viewModel.onTabSelected,
              tabs: const <String>[
                'All',
                'Clips',
                'Events',
                'Posts',
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ActivityEventTile(activity: state.events[index]),
            childCount: state.events.length,
          ),
        ),
      ],
    );
  }
}
