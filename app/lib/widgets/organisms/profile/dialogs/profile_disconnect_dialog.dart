// Flutter imports:
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:unicons/unicons.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

class ProfileDisconnectDialog extends ConsumerWidget {
  const ProfileDisconnectDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final ProfileViewModel viewModel = ref.read(profileViewModelProvider.notifier);
    final ProfileViewModelState state = ref.watch(profileViewModelProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String displayName = state.profile?.displayName ?? '';

    return PositiveDialog(
      title: 'Remove Connection',
      children: <Widget>[
        Text(
          'Removing $displayName as a connection will mean you can  no longer message each other.',
          style: typography.styleBody.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: viewModel.onDisconnectSelected,
          icon: UniconsLine.user_times,
          label: 'Remove Connection',
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context),
          label: localizations.shared_actions_cancel,
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
