// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/hooks/feed_notifier_hook.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/events/notify_feed_seen_event.dart';
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

    final bool isLoggedOut = userController.currentUser == null;
    final List<Widget> actions = [
      ...buildCommonProfilePageActions(),
    ];

    final Profile? currentProfile = profileControllerState.currentProfile;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    const TargetFeed newFeed = TargetFeed(
      targetSlug: 'tags',
      targetUserId: 'everyone',
    );

    //? This is the new feed, as well as the signed out feed
    final String newFeedStateKey = PositiveFeedState.buildFeedCacheKey(newFeed);
    final PositiveFeedState newFeedState = cacheController.get(newFeedStateKey) ?? PositiveFeedState.buildNewState(feed: newFeed, currentProfileId: "");
    final Widget newFeedWidget = PositiveFeedPaginationBehaviour(
      currentProfile: currentProfile,
      feedState: newFeedState,
      feed: newFeed,
      isSliver: true,
    );

    final TargetFeed followingFeed = TargetFeed(
      targetSlug: 'timeline',
      targetUserId: currentProfileId,
    );

    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(followingFeed);
    final PositiveFeedState followingFeedState = cacheController.get(expectedFeedStateKey) ?? PositiveFeedState.buildNewState(feed: followingFeed, currentProfileId: currentProfileId);
    final Widget followingFeedWidget = PositiveFeedPaginationBehaviour(
      currentProfile: currentProfile,
      feedState: followingFeedState,
      feed: followingFeed,
      isSliver: true,
    );

    final List<TargetFeed> allTargetFeeds = <TargetFeed>[
      newFeed,
      followingFeed,
    ];

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [...allTargetFeeds]).toList();
    useCacheHook(keys: expectedCacheKeys);

    final Widget currentFeedWidget = switch (state.currentTabIndex) {
      0 => newFeedWidget,
      1 => followingFeedWidget,
      (_) => const SizedBox.shrink(),
    };

    final PositiveFeedState currentFeedState = switch (state.currentTabIndex) {
      0 => newFeedState,
      1 => followingFeedState,
      (_) => newFeedState,
    };

    void Function()? scrollToTop;
    String fabTitle = '';

    final ScrollController scrollController = useScrollController();
    final bool hasNewItems = useFeedNotifier(feedState: currentFeedState);
    final EventBus eventBus = ref.read(eventBusProvider);

    if (hasNewItems) {
      fabTitle = 'New Posts';
      scrollToTop = () {
        eventBus.fire(NotifyFeedSeedEvent());
        scrollController.animateTo(
          0,
          duration: kAnimationDurationRegular,
          curve: kAnimationCurveDefault,
        );
      };
    }

    // Check enabled state of the tabs
    final List<TargetFeed> disabledFeeds = ref.watch(systemControllerProvider.select((value) => value.disabledFeeds));
    final TargetFeed currentTargetFeed = allTargetFeeds[state.currentTabIndex];
    final bool isCurrentTabDisabled = disabledFeeds.contains(currentTargetFeed);

    final bool isNewFeedDisabled = TargetFeed.isFeedDisabled(newFeed, disabledFeeds);
    final bool isFollowingFeedDisabled = TargetFeed.isFeedDisabled(followingFeed, disabledFeeds);

    return PositiveScaffold(
      onWillPopScope: viewModel.onWillPopScope,
      onRefresh: () => currentFeedState.onRefresh(),
      appBarColor: colors.colorGray1,
      scrollController: scrollController,
      floatingActionLabel: fabTitle,
      onFloatingActionPressed: scrollToTop,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
        PositiveScaffoldComponent.footerPadding,
      },
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: NavigationBarIndex.hub,
        scrollController: scrollController,
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
            if (!isCurrentTabDisabled) ...<Widget>[
              PositiveHubFloatingBar(
                index: state.currentTabIndex,
                currentProfile: currentProfile,
                onTapped: viewModel.onTabSelected,
                topics: tagsControllerState.topicTags.values.toList(),
                onTopicSelected: viewModel.onTopicSelected,
                onSeeMoreTopicsSelected: viewModel.onSeeMoreTopicsSelected,
                tabs: <PositiveTabEntry>[
                  PositiveTabEntry(
                    title: 'New',
                    colour: colors.green,
                    isEnabled: !isNewFeedDisabled,
                  ),
                  PositiveTabEntry(
                    title: 'Following',
                    colour: colors.yellow,
                    isEnabled: !isFollowingFeedDisabled,
                  ),
                ],
              ),
            ],
          ],
        ),
        currentFeedWidget,
      ],
    );
  }
}
