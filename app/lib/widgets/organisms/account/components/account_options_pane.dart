// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../molecules/containers/positive_glass_sheet.dart';

class AccountOptionsPane extends ConsumerWidget {
  const AccountOptionsPane({
    super.key,
    required this.colors,
  });

  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final AccountViewModel viewModel = ref.read(accountViewModelProvider.notifier);
    ref.watch(accountViewModelProvider);

    return PositiveGlassSheet(
      children: <Widget>[
        PositiveButton(
          colors: colors,
          icon: UniconsLine.user_square,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_details,
          onTapped: () {},
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.bookmark,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_bookmarks,
          onTapped: () {},
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.users_alt,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_following,
          onTapped: () {},
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.sliders_v_alt,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_preferences,
          onTapped: () {},
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.sign_out_alt,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_logout,
          onTapped: () => viewModel.onSignOutRequested(context),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.feedback,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.teal,
          label: localizations.page_account_actions_feedback,
          onTapped: () => viewModel.onProvideFeedbackButtonPressed(context),
          // isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
