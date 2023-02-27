// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/providers/user/new_account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class RegistrationPasswordEntryPage extends ConsumerWidget {
  const RegistrationPasswordEntryPage({super.key});

  Color getTextFieldTintColor(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return colors.purple;
    }

    return controller.passwordValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return null;
    }

    return controller.passwordValidationResults.isNotEmpty ? PositiveTextFieldIcon.error(colors) : PositiveTextFieldIcon.success(colors);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NewAccountFormController controller = ref.read(newAccountFormControllerProvider.notifier);
    final NewAccountFormState state = ref.watch(newAccountFormControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    String errorMessage = localizations.fromValidationErrorList(controller.passwordValidationResults);
    bool shouldDisplayErrorMessage = state.password.isNotEmpty && errorMessage.isNotEmpty;

    //* If a controller threw an exception, we want to display that instead of the validation errors
    if (errorMessage.isEmpty) {
      errorMessage = localizations.fromObject(state.currentError);
      shouldDisplayErrorMessage = errorMessage.isNotEmpty;
    }

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      hideTrailingDecoration: true,
      trailingWidgets: <Widget>[
        ...hints,
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPasswordConfirmed,
          isDisabled: !controller.isPasswordValid,
          label: localizations.shared_actions_continue,
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQueryData.padding.top + kPaddingMedium,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PositiveAppBar(),
                const SizedBox(height: kPaddingMassive),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 6,
                  currentPage: 1,
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  'Create Password',
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingSmall),
                Text(
                  'Create a secure, non-repetitive password.',
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingLarge),
                PositiveTextField(
                  labelText: 'Password',
                  initialText: state.password,
                  onTextChanged: controller.onPasswordChanged,
                  tintColor: tintColor,
                  suffixIcon: suffixIcon,
                  obscureText: true,
                  isEnabled: !state.isBusy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
