// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class AccountSocialDisconnectionPage extends ConsumerWidget {
  const AccountSocialDisconnectionPage({super.key});

  Color getEmailTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.emailAddress.isEmpty) {
      return colors.purple;
    }

    return controller.emailValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  Color getPasswordTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return colors.purple;
    }

    return controller.passwordValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getEmailTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.emailAddress.isEmpty) {
      return null;
    }

    return controller.emailValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  PositiveTextFieldIcon? getPasswordTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return null;
    }

    return controller.passwordValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);
    final AccountFormState state = ref.watch(provider);

    final String emailErrorMessage = localizations.fromValidationErrorList(controller.emailValidationResults);
    final bool shouldDisplayEmailErrorMessage = state.emailAddress.isNotEmpty && emailErrorMessage.isNotEmpty;

    final String passwordErrorMessage = localizations.fromValidationErrorList(controller.passwordValidationResults);
    final bool shouldDisplayPasswordErrorMessage = state.password.isNotEmpty && passwordErrorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayEmailErrorMessage) ...<Widget>[
        PositiveHint.fromError(emailErrorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      if (shouldDisplayPasswordErrorMessage) ...<Widget>[
        PositiveHint.fromError(passwordErrorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      if (!shouldDisplayEmailErrorMessage && !shouldDisplayPasswordErrorMessage) ...<Widget>[
        PositiveHint.visibility(localizations.shared_form_defaults_hidden, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    final Color emailTextFieldTintColor = getEmailTextFieldTintColor(controller, colors);
    final Color passwordTextFieldTintColor = getPasswordTextFieldTintColor(controller, colors);

    final PositiveTextFieldIcon? emailSuffixIcon = getEmailTextFieldSuffixIcon(controller, colors);
    final PositiveTextFieldIcon? passwordSuffixIcon = getPasswordTextFieldSuffixIcon(controller, colors);

    final bool canContinue = controller.isEmailValid && controller.isPasswordValid;

    return PositiveGenericPage(
      title: 'Disable social sign in',
      body: 'To disable social sign in you must provide a new email address and password for your account.',
      canBack: true,
      currentStepIndex: 0,
      totalSteps: 3,
      includeDecorations: false,
      includeBadge: false,
      primaryActionText: 'Continue',
      canPerformPrimaryAction: canContinue,
      isBusy: state.isBusy,
      onPrimaryActionSelected: controller.onPasswordConfirmed,
      trailingWidgets: hints,
      children: <Widget>[
        PositiveTextField(
          labelText: localizations.shared_email_address,
          initialText: state.emailAddress,
          onTextChanged: controller.onEmailAddressChanged,
          textInputType: TextInputType.emailAddress,
          tintColor: emailTextFieldTintColor,
          suffixIcon: emailSuffixIcon,
          isEnabled: !state.isBusy,
          autofocus: true,
        ),
        PositiveTextField(
          labelText: localizations.page_registration_password_label,
          initialText: state.password,
          onTextChanged: controller.onPasswordChanged,
          onTextSubmitted: (_) => controller.onPasswordConfirmed(),
          tintColor: passwordTextFieldTintColor,
          suffixIcon: passwordSuffixIcon,
          isEnabled: !state.isBusy,
          obscureText: true,
          autocorrect: false,
        ),
      ],
    );
  }
}
