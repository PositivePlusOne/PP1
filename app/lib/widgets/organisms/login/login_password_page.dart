// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    return controller.passwordValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(LoginViewModel controller, DesignColorsModel colors) {
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
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final LoginViewModel viewModel = ref.watch(loginViewModelProvider.notifier);
    final LoginViewModelState state = ref.watch(loginViewModelProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(viewModel, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(viewModel, colors);

    final String errorMessage = localizations.fromValidationErrorList(viewModel.emailValidationResults);
    final bool shouldDisplayErrorMessage = state.password.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: true,
          children: <Widget>[
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
                  onTapped: viewModel.onPasswordResetSelected,
                  label: localizations.page_login_password_forgotten,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localizations.page_registration_password,
              obscureText: true,
              initialText: state.password,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.go,
              onTextSubmitted: viewModel.onPasswordSubmitted,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
            ),
          ],
        ),
      ],
      trailingWidgets: <Widget>[
        ...hints,
      ],
    );
  }
}
