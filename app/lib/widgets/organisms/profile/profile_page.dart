// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../behaviours/positive_feed_pagination_behaviour.dart';
import '../../molecules/lists/positive_profile_actions_list.dart';
import '../../molecules/tiles/positive_profile_tile.dart';
import '../../molecules/tiles/profile_biography_tile.dart';
import 'components/profile_app_bar_header.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    super.key,
  });

  Widget buildBlockedProfilePage() {
    return PositiveGenericPage(
      title: 'You are not allowed to view this page',
      body: 'You are not allowed to view this profile, if you think this is an error, please check out our app guidance.',
      buttonText: 'Back',
      style: PositiveGenericPageStyle.decorated,
      onContinueSelected: () async => providerContainer.read(appRouterProvider).removeLast(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileViewModelState state = ref.watch(profileViewModelProvider);
    final ProfileViewModel viewModel = ref.read(profileViewModelProvider.notifier);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ProfileControllerState controllerState = ref.watch(profileControllerProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final Profile? currentProfile = controllerState.currentProfile;
    final Profile? targetProfile = cacheController.get(state.targetProfileId ?? '');
    final bool isTargetProfile = currentProfile?.flMeta?.id == targetProfile?.flMeta?.id;
    final String targetProfileId = targetProfile?.flMeta?.id ?? '';

    final String relationshipId = [currentProfile?.flMeta?.id ?? '', targetProfileId].asGUID;
    final Relationship? relationship = cacheController.get(relationshipId);
    final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentProfile?.flMeta?.id ?? '') ?? {};
    final bool isBlockedByTarget = relationshipStates.contains(RelationshipState.targetBlocked);
    if (isBlockedByTarget) {
      return buildBlockedProfilePage();
    }

    final String expectedProfileStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: targetProfileId);
    final ProfileStatistics? profileStatistics = cacheController.get(expectedProfileStatisticsKey);
    final Map<String, String> profileStatisticsData = ProfileStatistics.getDisplayItems(profileStatistics, appLocalizations);

    //* Check for a cover image
    final Media? coverImage = targetProfile?.coverImage;

    final TargetFeed targetFeed = TargetFeed(
      targetSlug: 'user',
      targetUserId: targetProfile?.flMeta?.id ?? '',
    );

    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(targetFeed);
    final PositiveFeedState feedState = cacheController.get(expectedFeedStateKey) ?? PositiveFeedState.buildNewState(feed: targetFeed, currentProfileId: currentProfile?.flMeta?.id ?? '');

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [targetProfile, targetFeed, profileStatistics]).toList();

    useLifecycleHook(viewModel);
    usePageRefreshHook();

    useCacheHook(keys: expectedCacheKeys);

    final Color appBarColor = targetProfile?.accentColor.toSafeColorFromHex() ?? colors.yellow;
    final Color appBarTextColor = appBarColor.complimentTextColor;

    // Check for if you're currently a managed profile viewing themselves
    // If so, we can remove the actions list
    final bool isCurrentlyViewingSelfAsManaged = isTargetProfile && profileController.isCurrentlyManagedProfile;

    PreferredSizeWidget? appBarBottomWidget;
    if (targetProfile != null) {
      appBarBottomWidget = ProfileAppBarHeader(
        profile: targetProfile,
        children: <PreferredSizeWidget>[
          PositiveProfileTile(
            profile: targetProfile,
            brightness: appBarColor.impliedBrightness,
            enableProfileImageFullscreen: true,
            metadata: profileStatisticsData,
          ),
          if (!isCurrentlyViewingSelfAsManaged) ...<PreferredSizeWidget>[
            PositiveProfileActionsList(
              currentProfile: currentProfile,
              targetProfile: targetProfile,
              relationship: relationship,
            ),
          ],
        ],
      );
    }

    final List<Widget> actions = [];
    if (controllerState.currentProfile != null) {
      actions.addAll(controllerState.currentProfile!.buildCommonProfilePageActions(color: appBarTextColor));
    }

    return PositiveScaffold(
      appBarColor: appBarColor,
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      onRefresh: () => viewModel.onRefresh(
        feedState,
        expectedFeedStateKey,
      ),
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBar(
            title: targetProfile?.name.isNotEmpty == true ? targetProfile?.displayName.asHandle ?? '' : '',
            centerTitle: true,
            includeLogoWherePossible: false,
            foregroundColor: appBarTextColor,
            backgroundColor: appBarColor,
            decorationColor: colors.colorGray1,
            backgroundImage: coverImage,
            trailType: PositiveAppBarTrailType.concave,
            applyLeadingandTrailingPadding: true,
            safeAreaQueryData: mediaQueryData,
            bottom: appBarBottomWidget,
            leading: PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: appBarTextColor,
              icon: UniconsLine.angle_left_b,
              onTapped: () => router.removeLast(),
            ),
            trailing: actions,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              //! as gallery has been removed from MVP this tab bar is not needed
              // PositiveTabBar(
              //   onTapped: (_) {},
              //   tabs: [
              //     localizations.shared_ui_posts,
              //     localizations.shared_ui_gallery,
              //   ],
              // ),
              // const SizedBox(height: kPaddingSmall),
              Container(
                padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
                child: ProfileBiographyTile(
                  profile: targetProfile!,
                  isBusy: state.isBusy,
                  displayDetailsOption: !targetProfile.isOrganisation,
                ),
              ),
              // if (targetProfile?.interests.isNotEmpty == true) ...<Widget>[
              //   Padding(
              //     padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
              //     child: PositiveProfileInterestsList(profile: targetProfile!),
              //   ),
              // ],
            ],
          ),
        ),
        PositiveFeedPaginationBehaviour(
          currentProfile: currentProfile,
          feed: targetFeed,
          feedState: feedState,
        ),
      ],
    );
  }
}
