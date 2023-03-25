// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';

class ProfileAppBarHeader extends ConsumerWidget with PreferredSizeWidget {
  const ProfileAppBarHeader({
    super.key,
    required this.state,
    required this.viewModel,
  });

  final ProfileViewModel viewModel;
  final ProfileViewModelState state;

  static const double kButtonListHeight = 42.0;
  static const double kButtonBottomPadding = 10.0;

  @override
  Size get preferredSize {
    double height = 0.0;

    //* Add height for all the profile components
    if (state.userProfile != null) {
      height += kButtonListHeight;
      height += kButtonBottomPadding;
    }

    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((design) => design.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((design) => design.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: preferredSize.height,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          if (state.userProfile != null) ...<Widget>[
            SizedBox(
              height: kButtonListHeight,
              width: double.infinity,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    onTapped: () {},
                    label: localizations.shared_actions_follow,
                    icon: UniconsLine.plus_circle,
                    layout: PositiveButtonLayout.iconLeft,
                    size: PositiveButtonSize.medium,
                    forceIconPadding: true,
                  ),
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    onTapped: viewModel.onConnectSelected,
                    label: localizations.shared_actions_connect,
                    icon: UniconsLine.user_plus,
                    layout: PositiveButtonLayout.iconLeft,
                    size: PositiveButtonSize.medium,
                    forceIconPadding: true,
                    isDisabled: state.connectingState == PositiveTogglableState.loading,
                  ),
                ].spaceWithHorizontal(kPaddingSmall),
              ),
            ),
            const SizedBox(height: kButtonBottomPadding),
          ],
        ],
      ),
    );
  }
}
