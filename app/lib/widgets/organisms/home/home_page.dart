// Flutter imports:
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import 'components/hub_app_bar_content.dart';
import 'components/positive_hub_floating_bar.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);
    final HomeViewModelState state = ref.watch(homeViewModelProvider);

    final UserController userController = ref.read(userControllerProvider.notifier);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);
    usePageRefreshHook();

    final bool isLoggedOut = userController.currentUser == null;
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      onRefresh: viewModel.onRefresh,
      refreshController: viewModel.refreshController,
      refreshBackgroundColor: colors.white,
      onWillPopScope: viewModel.onWillPopScope,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
        PositiveScaffoldComponent.footerPadding,
      },
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: NavigationBarIndex.hub,
      ),
      headingWidgets: <Widget>[
        StickyPositiveAppBar(
          foregroundColor: colors.black,
          backgroundColor: colors.pink,
          decorationColor: colors.colorGray1,
          bottom: HubAppBarContent(shouldDisplayActivateAccountBanner: isLoggedOut),
          floating: PositiveHubFloatingBar(
            activities: [
              for (int i = 0; i < 10; i++) ...<Activity>[
                Activity(generalConfiguration: ActivityGeneralConfiguration(content: 'Tag ${i + 1}')),
              ],
            ],
            index: state.currentTabIndex,
            onTapped: viewModel.onTabSelected,
            tabs: const <String>[
              'All',
              'Clips',
              'Events',
              'Posts',
            ],
          ),
          trailType: PositiveAppBarTrailType.convex,
          actions: actions,
        ),
        if (!isLoggedOut) ...<Widget>[
          PositiveFeedPaginationBehaviour(
            feed: 'timeline',
            slug: userController.currentUser!.uid,
          ),
        ],
      ],
    );
  }
}
