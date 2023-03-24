// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/enuumerations/positive_togglable_state.dart';
import 'components/profile_app_bar_header.dart';

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

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    String title = '';
    if (state.pageState == PositiveTogglableState.active) {
      title = state.userProfile!.name;
    }

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBar(
            title: title,
            includeLogoWherePossible: false,
            backgroundColor: colors.teal, //! Select from the profile ideally
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
              if (state.pageState == PositiveTogglableState.error) ...<Widget>[
                Text(
                  localizations.shared_errors_defaults_body,
                  textAlign: TextAlign.center,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingSmall),
                Align(
                  alignment: Alignment.center,
                  child: IntrinsicWidth(
                    child: PositiveButton(
                      colors: colors,
                      onTapped: viewModel.loadProfile,
                      label: localizations.shared_errors_defaults_action,
                      primaryColor: colors.black,
                      style: PositiveButtonStyle.text,
                      size: PositiveButtonSize.small,
                    ),
                  ),
                ),
              ],
              if (state.pageState == PositiveTogglableState.active) ...<Widget>[
                Container(height: 300.0, width: double.infinity, color: Colors.amber),
                Container(height: 300.0, width: double.infinity, color: Colors.black),
                Container(height: 300.0, width: double.infinity, color: Colors.blue),
                Container(height: 300.0, width: double.infinity, color: Colors.brown),
                Container(height: 300.0, width: double.infinity, color: Colors.cyan),
                Container(height: 300.0, width: double.infinity, color: Colors.deepOrange),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
