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
    this.edgePadding = kPaddingNone,
    this.isOrganisation = false,
    this.accentColour = Colors.white,
  });

  final DesignColorsModel colors;
  final bool isOrganisation;
  final double edgePadding;
  final Color accentColour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edgePadding),
      child: PositiveGlassSheet(
        children: <Widget>[
          if (isOrganisation) ...getOrganisationWidgets(context, ref),
          if (!isOrganisation) ...getUserWidgets(context, ref),
        ],
      ),
    );
  }

  List<Widget> getUserWidgets(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.genericFeedback());
    final AccountViewModel viewModel = ref.watch(viewModelProvider.notifier);

    return [
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
        primaryColor: accentColour,
        iconColorOverride: colors.black,
        fontColorOverride: colors.black,
        label: localizations.page_account_actions_feedback,
        onTapped: () => viewModel.onProvideFeedbackButtonPressed(context),
        // isDisabled: state.isBusy,
      ),
    ];
  }

  List<Widget> getOrganisationWidgets(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.genericFeedback());
    final AccountViewModel viewModel = ref.watch(viewModelProvider.notifier);

    return [
      PositiveButton(
        colors: colors,
        icon: UniconsLine.list_ul,
        style: PositiveButtonStyle.primary,
        primaryColor: accentColour,
        label: localizations.page_account_organisation_actions_company_details,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.book,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_directory_details,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.external_link_alt,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_promoted,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.accessible_icon_alt,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_team,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.user_square,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_followers,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.chat_bubble_user,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_chat,
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveButton(
        colors: colors,
        icon: UniconsLine.layer_group,
        style: PositiveButtonStyle.ghost,
        primaryColor: colors.colorGray1,
        label: localizations.page_account_organisation_actions_leave("Company Name"),
        onTapped: viewModel.onAccountDetailsButtonSelected,
      ),
    ];
  }
}
