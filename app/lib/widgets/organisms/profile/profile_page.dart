// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../../providers/enumerations/positive_togglable_state.dart';
import '../../molecules/lists/positive_profile_actions_list.dart';
import '../../molecules/lists/positive_profile_interests_list.dart';
import '../../molecules/tiles/positive_profile_tile.dart';
import '../../molecules/tiles/profile_biography_tile.dart';
import 'components/profile_app_bar_header.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileViewModelProvider provider = profileViewModelProvider(userId);
    final ProfileViewModelState state = ref.watch(provider);
    final ProfileViewModel viewModel = ref.read(provider.notifier);
    final ProfileControllerState controllerState = ref.watch(profileControllerProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    PreferredSizeWidget? appBarBottomWidget;
    if (state.profile != null) {
      appBarBottomWidget = ProfileAppBarHeader(
        profile: state.profile!,
        children: <PreferredSizeWidget>[
          PositiveProfileTile(
            profile: state.profile!,
            metadata: const {
              'Followers': '1.2M',
              'Likes': '42k',
              'Posts': '120',
            },
          ),
          PositiveProfileActionsList(
            profile: state.profile!,
          ),
        ],
      );
    }

    final List<Widget> actions = [];
    if (controllerState.userProfile != null) {
      actions.addAll(controllerState.userProfile!.buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBar(
            includeLogoWherePossible: false,
            backgroundColor: viewModel.appBarColor, //TODO Select from the profile ideally
            trailType: PositiveAppBarTrailType.concave,
            decorationColor: colors.colorGray1,
            applyLeadingandTrailingPadding: true,
            safeAreaQueryData: mediaQueryData,
            bottom: appBarBottomWidget,
            leading: PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: colors.black,
              icon: UniconsLine.angle_left_b,
              onTapped: () => router.removeLast(),
            ),
            trailing: actions,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              if (state.pageState == PositiveTogglableState.loading) ...<Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: PositiveLoadingIndicator(),
                ),
              ],
              if (state.pageState == PositiveTogglableState.active && state.profile != null) ...<Widget>[
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
            ],
          ),
        ),
      ],
    );
  }
}
