// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class AccountUpdatePasswordPage extends ConsumerWidget {
  const AccountUpdatePasswordPage({super.key});

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return colors.purple;
    }

    return controller.passwordValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
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
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final Locale locale = Localizations.localeOf(context);
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);
    final AccountFormState state = ref.watch(provider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    final String errorMessage = localizations.fromValidationErrorList(controller.passwordValidationResults);
    final bool shouldDisplayErrorMessage = state.password.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      if (!shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.visibility('Hidden by default in the app', colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onChangePasswordRequested,
          isDisabled: !controller.isPasswordValid,
          label: controller.state.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
        ),
      ],
      trailingWidgets: hints,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            const PositiveBackButton(),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Change Password',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Please create a new password for your account.',
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: 'Password',
              initialText: state.password,
              onTextChanged: controller.onPasswordChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              obscureText: true,
              autocorrect: false,
              autofocus: true,
            ),
          ],
        ),
      ],
    );
  }
}
