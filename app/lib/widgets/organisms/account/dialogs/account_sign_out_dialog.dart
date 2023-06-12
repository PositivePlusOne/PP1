// Flutter imports:
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../../atoms/buttons/positive_button.dart';

class AccountSignOutDialog extends ConsumerWidget {
  const AccountSignOutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.unknown());
    final AccountViewModel viewModel = ref.read(viewModelProvider.notifier);
    final AccountViewModelState state = ref.watch(viewModelProvider);

    return PositiveDialog(
      title: 'Sign Out',
      children: <Widget>[
        Text(
          'Are you sure you would like to sign out of Positive+1?',
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => viewModel.onSignOutConfirmed(context),
          icon: UniconsLine.sign_out_alt,
          label: 'Sign Out',
          primaryColor: colors.teal,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context),
          label: 'Cancel',
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
