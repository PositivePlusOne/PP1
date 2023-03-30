// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

class RegistrationAccountPage extends ConsumerWidget {
  const RegistrationAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: viewModel.state.isBusy,
          onTapped: viewModel.onLoginWithGoogleSelected,
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
          isDisabled: viewModel.state.isBusy,
          onTapped: viewModel.onLoginWithAppleSelected,
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
          isDisabled: viewModel.state.isBusy,
          onTapped: viewModel.onSignUpWithEmailSelected,
          label: localizations.page_registration_create_account_action_continue_email,
          icon: UniconsLine.envelope_add,
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          outlineHoverColorOverride: colors.black,
        ),
        const SizedBox(height: kPaddingExtraLarge),
        PositiveButton(
          colors: colors,
          onTapped: viewModel.onSignInRequested,
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
      headingWidgets: <Widget>[
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
                const SizedBox(height: kPaddingMassive),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      isDisabled: false,
                      onTapped: viewModel.onBackSelected,
                      label: localizations.shared_actions_back,
                      style: PositiveButtonStyle.text,
                      layout: PositiveButtonLayout.textOnly,
                      size: PositiveButtonSize.small,
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
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
