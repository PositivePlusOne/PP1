// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

@RoutePage()
class RegistrationAccountPage extends ConsumerWidget {
  const RegistrationAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);

    final Locale locale = Localizations.localeOf(context);
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      headingWidgets: [
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(onBackSelected: viewModel.onBackSelected),
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
      ],
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
        //! TODO: Implement Facebook login
        // const SizedBox(height: kPaddingMedium),
        // PositiveButton(
        //   colors: colors,
        //   primaryColor: colors.black,
        //   isDisabled: true,
        //   onTapped: () async {},
        //   label: localizations.page_registration_create_account_action_continue_facebook,
        //   icon: UniconsLine.facebook_f,
        //   layout: PositiveButtonLayout.iconLeft,
        //   style: PositiveButtonStyle.primary,
        //   outlineHoverColorOverride: colors.black,
        // ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: viewModel.state.isBusy,
          onTapped: () => viewModel.onSignUpWithEmailSelected(context, controller),
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
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            height: PositiveButton.kButtonIconRadiusRegular,
          ),
        ),
      ],
    );
  }
}
