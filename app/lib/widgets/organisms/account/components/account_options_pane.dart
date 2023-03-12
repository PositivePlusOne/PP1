// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../molecules/containers/positive_glass_sheet.dart';

class AccountOptionsPane extends StatelessWidget {
  const AccountOptionsPane({
    super.key,
    required this.colors,
  });

  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
          onTapped: () {},
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          icon: UniconsLine.feedback,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.teal,
          label: localizations.page_account_actions_feedback,
          onTapped: () {},
        ),
      ],
    );
  }
}
