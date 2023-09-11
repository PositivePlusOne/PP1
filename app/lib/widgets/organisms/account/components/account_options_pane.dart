// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/feedback/feedback_type.dart';
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

    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.genericFeedback());
    final AccountViewModel viewModel = ref.watch(viewModelProvider.notifier);

    return PositiveGlassSheet(
      children: <Widget>[
        PositiveButton(
          colors: colors,
          icon: UniconsLine.user_square,
          style: PositiveButtonStyle.ghost,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_details,
          onTapped: viewModel.onAccountDetailsButtonSelected,
        ),
        //! PP1-984
        // const SizedBox(height: kPaddingMedium),
        // PositiveButton(
        //   colors: colors,
        //   icon: UniconsLine.bookmark,
        //   style: PositiveButtonStyle.ghost,
        //   primaryColor: colors.colorGray1,
        //   label: localizations.page_account_actions_bookmarks,
        //   onTapped: () {},
        //   isDisabled: true,
        // ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.users_alt,
          style: PositiveButtonStyle.ghost,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_following,
          onTapped: viewModel.onMyCommunitiesButtonPressed,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.sliders_v_alt,
          style: PositiveButtonStyle.ghost,
          primaryColor: colors.colorGray1,
          label: localizations.page_account_actions_preferences,
          onTapped: () => viewModel.onAccountPreferencesRequested(context),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.sign_out_alt,
          style: PositiveButtonStyle.ghost,
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
          iconColorOverride: colors.black,
          fontColorOverride: colors.black,
          label: localizations.page_account_actions_feedback,
          onTapped: () => viewModel.onProvideFeedbackButtonPressed(context),
          // isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
