// Flutter imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
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
    final TagsControllerState tagsControllerState = ref.watch(tagsControllerProvider);

    final CacheController cacheController = ref.read(cacheControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);
    usePageRefreshHook();

    final bool isLoggedOut = userController.currentUser == null;
    final List<Widget> actions = [];

    final Profile? currentProfile = profileControllerState.currentProfile;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    final TargetFeed targetFeed = TargetFeed(
      targetSlug: 'timeline',
      targetUserId: currentProfileId,
    );

    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(targetFeed);
    final PositiveFeedState? feedState = cacheController.get(expectedFeedStateKey);

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [targetFeed]).toList();
    useCacheHook(keys: expectedCacheKeys);

    return PositiveScaffold(
      onWillPopScope: viewModel.onWillPopScope,
      appBarColor: colors.pink,
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
        PositiveBasicSliverList(
          foregroundColor: colors.black,
          backgroundColor: colors.pink,
          appBarTrailing: actions,
          appBarTrailType: PositiveAppBarTrailType.convex,
          appBarBottom: HubAppBarContent(shouldDisplayActivateAccountBanner: isLoggedOut),
          appBarSpacing: kPaddingNone,
          horizontalPadding: kPaddingNone,
          children: <Widget>[
            PositiveHubFloatingBar(
              index: state.currentTabIndex,
              onTapped: viewModel.onTabSelected,
              topics: tagsControllerState.topicTags.values.toList(),
              onTopicSelected: viewModel.onTopicSelected,
              onSeeMoreTopicsSelected: viewModel.onSeeMoreTopicsSelected,
              tabColours: <Color>[
                colors.green,
                // colors.yellow,
                colors.teal,
                colors.purple,
              ],
              tabs: const <String>[
                'All',
                // 'Clips',
                'Events',
                'Posts',
              ],
            ),
          ],
        ),
        if (!isLoggedOut) ...<Widget>[
          PositiveFeedPaginationBehaviour(
            currentProfile: currentProfile,
            feedState: feedState,
            feed: targetFeed,
          ),
        ],
      ],
    );
  }
}
