// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/components/feed_list_builder.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_tab_bar.dart';
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
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    final bool shouldDisplayActivateAccountBanner = userControllerState.user == null;
    final List<Widget> actions = [];

    if (profileControllerState.userProfile != null) {
      actions.addAll(profileControllerState.userProfile!.buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      onWillPopScope: viewModel.onWillPopScope,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: 0,
      ),
      headingWidgets: <Widget>[
        StickyPositiveAppBar(
          foregroundColor: colors.black,
          backgroundColor: colors.pink,
          decorationColor: colors.colorGray1,
          bottom: HubAppBarContent(
            shouldDisplayActivateAccountBanner: shouldDisplayActivateAccountBanner,
          ),
          floating: PositiveTabBar(
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
        SliverToBoxAdapter(
          child: FeedListBuilder.wrapWithClient(
            ref: ref,
            feed: 'event',
            shrinkWrap: true,
            enrichmentFlags: EnrichmentFlags()
              ..withReactionCounts()
              ..withOwnReactions(),
          ),
        ),
      ],
    );
  }
}
