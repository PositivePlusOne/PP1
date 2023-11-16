// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
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
    if (currentProfileId.isNotEmpty) {
      actions.addAll(profileControllerState.currentProfile?.buildCommonProfilePageActions() ?? []);
    }

    final TargetFeed timelineFeed = TargetFeed(
      targetSlug: 'timeline',
      targetUserId: currentProfileId,
    );

    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(timelineFeed);
    final PositiveFeedState profileTimelineFeedState = cacheController.get(expectedFeedStateKey) ?? PositiveFeedState.buildNewState(feed: timelineFeed, currentProfileId: currentProfileId);

    const TargetFeed everyoneTargetFeed = TargetFeed(
      targetSlug: 'tags',
      targetUserId: 'everyone',
    );

    final String everyoneFeedStateKey = PositiveFeedState.buildFeedCacheKey(everyoneTargetFeed);
    final PositiveFeedState everyoneFeedState = cacheController.get(everyoneFeedStateKey) ?? PositiveFeedState.buildNewState(feed: everyoneTargetFeed, currentProfileId: currentProfileId);
    final Widget everyoneFeedWidget = PositiveFeedPaginationBehaviour(
      currentProfile: currentProfile,
      feedState: everyoneFeedState,
      feed: everyoneTargetFeed,
      isSliver: true,
    );

    final TargetFeed postTargetFeed = TargetFeed.fromTag('post');
    final String postFeedStateKey = PositiveFeedState.buildFeedCacheKey(TargetFeed.fromTag('post'));
    final PositiveFeedState postFeedState = cacheController.get(postFeedStateKey) ?? PositiveFeedState.buildNewState(feed: TargetFeed.fromTag('post'), currentProfileId: currentProfileId);
    final Widget postFeedWidget = PositiveFeedPaginationBehaviour(
      currentProfile: currentProfile,
      feedState: postFeedState,
      feed: postTargetFeed,
      isSliver: true,
    );

    final TargetFeed clipTargetFeed = TargetFeed.fromTag('clip');
    final String clipFeedStateKey = PositiveFeedState.buildFeedCacheKey(TargetFeed.fromTag('clip'));
    final PositiveFeedState clipFeedState = cacheController.get(clipFeedStateKey) ?? PositiveFeedState.buildNewState(feed: TargetFeed.fromTag('clip'), currentProfileId: currentProfileId);
    final Widget clipFeedWidget = PositiveFeedPaginationBehaviour(
      currentProfile: currentProfile,
      feedState: clipFeedState,
      feed: clipTargetFeed,
      isSliver: true,
    );

    final List<TargetFeed> allTargetFeeds = <TargetFeed>[
      timelineFeed,
      everyoneTargetFeed,
      postTargetFeed,
      clipTargetFeed,
    ];

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [...allTargetFeeds]).toList();
    useCacheHook(keys: expectedCacheKeys);

    final ScrollController controller = useScrollController();

    Widget allFeedWidget = everyoneFeedWidget;
    final bool canUseProfileTimelineFeed = !isLoggedOut && profileTimelineFeedState.pagingController.itemList?.isNotEmpty == true;
    if (canUseProfileTimelineFeed) {
      allFeedWidget = PositiveFeedPaginationBehaviour(
        currentProfile: currentProfile,
        feedState: profileTimelineFeedState,
        feed: timelineFeed,
        isSliver: true,
      );
    }

    final currentFeedWidget = switch (state.currentTabIndex) {
      0 => allFeedWidget,
      1 => postFeedWidget,
      2 => clipFeedWidget,
      (_) => const SizedBox.shrink(),
    };

    final PositiveFeedState currentFeedState = switch (state.currentTabIndex) {
      1 => postFeedState,
      2 => clipFeedState,
      (_) => canUseProfileTimelineFeed ? profileTimelineFeedState : everyoneFeedState,
    };

    return PositiveScaffold(
      onWillPopScope: viewModel.onWillPopScope,
      onRefresh: () => currentFeedState.onRefresh(),
      appBarColor: colors.colorGray1,
      controller: controller,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
        PositiveScaffoldComponent.footerPadding,
      },
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: NavigationBarIndex.hub,
        scrollController: controller,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: colors.black,
          backgroundColor: colors.colorGray1,
          appBarTrailing: actions,
          appBarBottom: HubAppBarContent(shouldDisplayActivateAccountBanner: isLoggedOut),
          appBarSpacing: kPaddingNone,
          horizontalPadding: kPaddingNone,
          children: <Widget>[
            PositiveHubFloatingBar(
              index: state.currentTabIndex,
              currentProfile: currentProfile,
              onTapped: viewModel.onTabSelected,
              topics: tagsControllerState.topicTags.values.toList(),
              onTopicSelected: viewModel.onTopicSelected,
              onSeeMoreTopicsSelected: viewModel.onSeeMoreTopicsSelected,
              tabColours: <Color>[
                colors.green,
                colors.purple,
                colors.yellow,
              ],
              tabs: const <String>[
                'All',
                'Posts',
                'Clips',
              ],
            ),
          ],
        ),
        currentFeedWidget,
      ],
    );
  }
}
