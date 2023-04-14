// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../../providers/enumerations/positive_togglable_state.dart';
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

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    String title = '';
    if (state.pageState == PositiveTogglableState.active) {
      title = state.userProfile?.displayName ?? '';
    }

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBar(
            title: title,
            includeLogoWherePossible: false,
            backgroundColor: viewModel.appBarColor, //! Select from the profile ideally
            trailType: PositiveAppBarTrailType.concave,
            decorationColor: colors.colorGray1,
            applyLeadingandTrailingPadding: true,
            safeAreaQueryData: mediaQueryData,
            bottom: ProfileAppBarHeader(state: state, viewModel: viewModel),
            leading: PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: colors.black,
              icon: UniconsLine.angle_left_b,
              onTapped: () => router.removeLast(),
            ),
            trailing: <Widget>[
              PositiveButton.appBarIcon(
                colors: colors,
                icon: UniconsLine.bell,
                onTapped: () async {},
                isDisabled: true,
              ),
              PositiveButton.appBarIcon(
                colors: colors,
                icon: UniconsLine.user,
                onTapped: viewModel.onAccountSelected,
              ),
            ],
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
            ],
          ),
        ),
      ],
    );
  }
}
