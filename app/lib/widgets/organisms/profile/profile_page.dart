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
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../behaviours/positive_feed_pagination_behaviour.dart';
import '../../molecules/lists/positive_profile_actions_list.dart';
import '../../molecules/lists/positive_profile_interests_list.dart';
import '../../molecules/tiles/positive_profile_tile.dart';
import '../../molecules/tiles/profile_biography_tile.dart';
import 'components/profile_app_bar_header.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    super.key,
  });

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
    final List<String> members = <String>[
      controllerState.currentProfile?.flMeta?.id ?? '',
      state.profile?.flMeta?.id ?? '',
    ];

    final Profile? currentProfile = controllerState.currentProfile;
    final Profile targetProfile = state.profile ?? Profile.empty();
    final Relationship relationship = state.relationship ?? Relationship.empty(members);

    final String expectedProfileStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: targetProfile.flMeta?.id ?? '');
    final ProfileStatistics? profileStatistics = cacheController.get(expectedProfileStatisticsKey);
    final Map<String, String> profileStatisticsData = ProfileStatistics.getDisplayItems(profileStatistics, appLocalizations);

    //* Check for a cover image
    final Media? coverImage = targetProfile.coverImage;

    final TargetFeed targetFeed = TargetFeed(
      targetSlug: 'user',
      targetUserId: targetProfile.flMeta?.id ?? '',
    );

    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(targetFeed);
    final PositiveFeedState feedState = cacheController.get(expectedFeedStateKey) ?? PositiveFeedState.buildNewState(feed: targetFeed, currentProfileId: currentProfile?.flMeta?.id ?? '');

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [targetProfile, targetFeed, profileStatistics]).toList();

    useLifecycleHook(viewModel);
    usePageRefreshHook();

    useCacheHook(keys: expectedCacheKeys);

    final bool isOrganisation = targetProfile.isOrganisation;

    PreferredSizeWidget? appBarBottomWidget;
    if (state.profile != null) {
      appBarBottomWidget = ProfileAppBarHeader(
        profile: state.profile!,
        children: <PreferredSizeWidget>[
          PositiveProfileTile(
            profile: state.profile ?? Profile.empty(),
            brightness: viewModel.appBarColor.impliedBrightness,
            enableProfileImageFullscreen: true,
            metadata: profileStatisticsData,
          ),
          PositiveProfileActionsList(
            currentProfile: currentProfile,
            targetProfile: targetProfile,
            relationship: relationship,
          ),
        ],
      );
    }

    final List<Widget> actions = [];
    if (controllerState.currentProfile != null) {
      actions.addAll(controllerState.currentProfile!.buildCommonProfilePageActions(color: viewModel.appBarTextColor));
    }

    return PositiveScaffold(
      appBarColor: viewModel.appBarColor,
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBar(
            title: targetProfile.name.isNotEmpty ? targetProfile.displayName.asHandle : '',
            centerTitle: true,
            includeLogoWherePossible: false,
            foregroundColor: viewModel.appBarTextColor,
            backgroundColor: viewModel.appBarColor,
            decorationColor: colors.colorGray1,
            backgroundImage: coverImage,
            trailType: PositiveAppBarTrailType.concave,
            applyLeadingandTrailingPadding: true,
            safeAreaQueryData: mediaQueryData,
            bottom: appBarBottomWidget,
            leading: PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: viewModel.appBarTextColor,
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
              //const SizedBox(height: kPaddingSmall),
              if (state.profile!.biography.isNotEmpty) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
                  child: ProfileBiographyTile(profile: state.profile!),
                ),
              ],
              if (state.profile!.interests.isNotEmpty) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
                  child: PositiveProfileInterestsList(profile: state.profile!),
                ),
              ],
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
