// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
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
    final ProfileControllerState controllerState = ref.watch(profileControllerProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final List<String> members = <String>[
      controllerState.currentProfile?.flMeta?.id ?? '',
      state.profile?.flMeta?.id ?? '',
    ];

    //* This is protected by the ProfileDisplayGuard
    final Profile targetProfile = state.profile ?? Profile.empty();
    final Relationship relationship = state.relationship ?? Relationship.empty(members);

    useLifecycleHook(viewModel);
    usePageRefreshHook();

    PreferredSizeWidget? appBarBottomWidget;
    if (state.profile != null) {
      appBarBottomWidget = ProfileAppBarHeader(
        profile: state.profile!,
        children: <PreferredSizeWidget>[
          PositiveProfileTile(
            profile: state.profile ?? Profile.empty(),
            brightness: viewModel.appBarColor.impliedBrightness,
            metadata: {
              'Followers': '${state.profile?.statistics.followers ?? 0}',
              'Following': '${state.profile?.statistics.following ?? 0}',
            },
          ),
          PositiveProfileActionsList(
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
            includeLogoWherePossible: false,
            backgroundColor: viewModel.appBarColor,
            trailType: PositiveAppBarTrailType.concave,
            decorationColor: colors.colorGray1,
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
          feed: TargetFeed('user', targetProfile.flMeta?.id ?? ''),
        ),
      ],
    );
  }
}
