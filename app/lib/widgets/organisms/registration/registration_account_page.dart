import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/organisms/registration/registration_account_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/design_constants.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

class RegistrationAccountPage extends ConsumerWidget {
  const RegistrationAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final RegistrationAccountController registrationAccountController = ref.watch(registrationAccountControllerProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      backgroundColor: colors.white,
      trailingWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: true,
          onTapped: () async {},
          label: localizations.page_registration_create_account_action_continue_google,
          icon: UniconsLine.google,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          outlineHoverColorOverride: colors.black,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: true,
          onTapped: () async {},
          label: localizations.page_registration_create_account_action_continue_apple,
          icon: UniconsLine.apple,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          outlineHoverColorOverride: colors.black,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: true,
          onTapped: () async {},
          label: localizations.page_registration_create_account_action_continue_facebook,
          icon: UniconsLine.facebook_f,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          outlineHoverColorOverride: colors.black,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: false,
          onTapped: registrationAccountController.onLoginWithEmailSelected,
          label: localizations.page_registration_create_account_action_continue_email,
          icon: UniconsLine.envelope_add,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          outlineHoverColorOverride: colors.black,
        ),
        const SizedBox(height: kPaddingExtraLarge),
        PositiveButton(
          colors: colors,
          isDisabled: true,
          onTapped: () async {},
          label: localizations.page_registration_create_account_action_continue_login,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.pink,
          iconWidgetBuilder: (Color color) => SvgPicture.asset(
            SvgImages.logosCircular,
            color: color,
            height: PositiveButton.kButtonIconRadiusRegular,
          ),
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PositiveAppBar(),
                const SizedBox(height: kPaddingSection),
                Text(
                  localizations.page_registration_create_account_title,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_registration_create_account_body,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
