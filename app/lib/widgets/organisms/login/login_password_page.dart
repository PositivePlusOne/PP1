// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/shared/animations/positive_expandable_widget.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class LoginPasswordPage extends ConsumerWidget {
  const LoginPasswordPage({super.key});

  Color getTextFieldTintColor(LoginViewModel controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return colors.purple;
    }

    return passwordValidation(controller) ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(LoginViewModel controller, DesignColorsModel colors) {
    if (controller.state.password.isEmpty) {
      return null;
    }

    return passwordValidation(controller)
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  bool passwordValidation(LoginViewModel controller) {
    return controller.passwordValidationResults.isNotEmpty || controller.state.serverError.isNotEmpty;
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

    final String errorMessage = localizations.fromValidationErrorList(viewModel.passwordValidationResults);
    final bool shouldDisplayErrorMessage = state.password.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (state.serverError.isNotEmpty) ...<Widget>[
        const SizedBox(height: kPaddingMedium),
        PositiveHint.fromError(state.serverError, colors),
      ],
      if (shouldDisplayErrorMessage) ...<Widget>[
        const SizedBox(height: kPaddingMedium),
        PositiveHint.fromError(errorMessage, colors),
      ],
    ];

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: true,
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_welcome_back,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_login_password_enter,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  isDisabled: false,
                  onTapped: () => viewModel.onPasswordResetOptionSelected(),
                  label: localizations.page_login_password_forgotten,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localizations.page_registration_password_label,
              obscureText: true,
              initialText: state.password,
              textInputType: TextInputType.text,
              onTextChanged: viewModel.updatePassword,
              onTextSubmitted: (_) => viewModel.onPasswordSubmitted(context),
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              autocorrect: false,
              autofocus: true,
            ),
            PositiveExpandableWidget(
              collapsedChild: const SizedBox.shrink(),
              expandedChild: Column(children: hints),
              isExpanded: hints.isNotEmpty,
            ),
          ],
        ),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: () => viewModel.onPasswordSubmitted(context),
          label: localizations.shared_actions_continue,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
          layout: PositiveButtonLayout.textOnly,
        ),
      ],
    );
  }
}
