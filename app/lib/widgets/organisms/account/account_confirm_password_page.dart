// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_hint.dart';

enum AccountConfirmPageType {
  delete,
}

@RoutePage()
class AccountConfirmPasswordPage extends ConsumerWidget {
  final AccountConfirmPageType pageType;
  const AccountConfirmPasswordPage({super.key, required this.pageType});

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

  Future<void> _completePage(AccountFormController controller, LoginViewModel viewModel) async {
    // first confirm the password they entered
    switch (pageType) {
      case AccountConfirmPageType.delete:
        {
          await viewModel.onAccountDeleteOptionSelected();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final Locale locale = Localizations.localeOf(context);
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);
    final AccountFormState state = ref.watch(provider);

    final LoginViewModel viewModel = ref.watch(loginViewModelProvider.notifier);
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
    ];

    return PositiveScaffold(
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: () => _completePage(controller, viewModel),
          // isDisabled: !controller.isPasswordValid,
          label: pageType == AccountConfirmPageType.delete
              // when confirm to delete - show the delete text
              ? localizations.page_confirm_password_delete_button
              // else show the standard form mode button texts
              : controller.state.formMode == FormMode.edit
                  ? localizations.shared_actions_confirm
                  : localizations.shared_actions_continue,
        ),
      ],
      trailingWidgets: hints,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(label: localizations.shared_actions_cancel),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_account_actions_change_delete_account_confirm_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_account_actions_change_delete_account_confirm_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            // const SizedBox(height: kPaddingSmall),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: IntrinsicWidth(
            //     child: PositiveButton(
            //       colors: colors,
            //       primaryColor: colors.black,
            //       isDisabled: false,
            //       onTapped: () => viewModel.onPasswordResetOptionSelected(),
            //       label: localizations.page_login_password_forgotten,
            //       style: PositiveButtonStyle.text,
            //       layout: PositiveButtonLayout.textOnly,
            //       size: PositiveButtonSize.small,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: kPaddingMedium),
            // PositiveTextField(
            //   labelText: 'Password',
            //   initialText: state.password,
            //   onTextChanged: controller.onPasswordChanged,
            //   tintColor: tintColor,
            //   suffixIcon: suffixIcon,
            //   isEnabled: !state.isBusy,
            //   obscureText: true,
            //   autocorrect: false,
            //   autofocus: true,
            // ),
          ],
        ),
      ],
    );
  }
}
