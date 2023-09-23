// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({
    super.key,
    required this.senderRoute,
  });

  final Type senderRoute;

  Color getTextFieldTintColor(LoginViewModel controller, DesignColorsModel colors) {
    if (controller.state.email.isEmpty) {
      return colors.purple;
    }

    return controller.emailValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(LoginViewModel controller, DesignColorsModel colors) {
    if (controller.state.email.isEmpty) {
      return null;
    }

    return controller.emailValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(
            backgroundColor: colors.green,
            isEnabled: !controller.state.isBusy,
            onTap: controller.onEmailSubmitted,
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final LoginViewModel viewModel = ref.watch(loginViewModelProvider.notifier);
    final LoginViewModelState state = ref.watch(loginViewModelProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(viewModel, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(viewModel, colors);

    final String errorMessage = localizations.fromValidationErrorList(viewModel.emailValidationResults);
    final bool shouldDisplayErrorMessage = state.email.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingSmall),
      ],
    ];

    return PositiveScaffold(
      onWillPopScope: viewModel.onBackSelected,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: true,
          children: <Widget>[
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
              'Sign In',
              style: typography.styleHero.copyWith(color: colors.black),
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
        PositiveTextField(
          labelText: 'Continue With Email',
          initialText: state.email,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.go,
          onTextChanged: viewModel.updateEmail,
          onTextSubmitted: (_) => viewModel.onEmailSubmitted(context),
          tintColor: tintColor,
          suffixIcon: suffixIcon,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingSmall),
        ...hints,
        Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: PositiveButton(
              colors: colors,
              primaryColor: colors.black,
              onTapped: viewModel.onAccountRecoverySelected,
              label: 'Forgotten Email',
              layout: PositiveButtonLayout.textOnly,
              style: PositiveButtonStyle.text,
              size: PositiveButtonSize.medium,
              outlineHoverColorOverride: colors.black,
            ),
          ),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => viewModel.onSignUpRequested(senderRoute),
          label: 'Need to Make an Account?',
          layout: PositiveButtonLayout.iconLeft,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.yellow,
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
