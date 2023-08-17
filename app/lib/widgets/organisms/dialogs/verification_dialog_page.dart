// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../providers/system/design_controller.dart';

@RoutePage()
class VerificationDialogPage extends StatefulHookConsumerWidget {
  const VerificationDialogPage({
    required this.onVerified,
    required this.emailAddress,
    super.key,
  });

  final Future<void> Function() onVerified;
  final String emailAddress;

  @override
  ConsumerState<VerificationDialogPage> createState() => _VerificationDialogPageState();
}

class VerificationDialogPageValidator extends AbstractValidator<_VerificationDialogPageState> {
  VerificationDialogPageValidator() {
    ruleFor((e) => e.currentPassword, key: 'password').meetsPasswordComplexity();
  }
}

class _VerificationDialogPageState extends ConsumerState<VerificationDialogPage> {
  final VerificationDialogPageValidator validator = VerificationDialogPageValidator();

  List<ValidationError> get passwordValidationResults => validator.validate(this).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty;

  String currentPassword = '';
  bool isBusy = false;
  TextEditingController? passwordController;
  FocusNode? passwordFocusNode;

  String get cacheKey => 'verification_${widget.emailAddress}';

  Color getTextFieldTintColor(DesignColorsModel colors) {
    if (currentPassword.isEmpty) {
      return colors.purple;
    }

    return isPasswordValid ? colors.green : colors.red;
  }

  void onPasswordChanged(String password) {
    currentPassword = password;
    setStateIfMounted();
  }

  Future<void> onPasswordConfirmed() async {
    if (!isPasswordValid) {
      return;
    }

    await PositiveScaffold.dismissKeyboardIfPresent(context);
    isBusy = true;
    setStateIfMounted();

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.confirmPassword(currentPassword);
      await widget.onVerified();
    } finally {
      isBusy = false;
      setStateIfMounted();
    }
  }

  Future<void> onPasswordResetSelected(BuildContext context) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final String snackbarBody = appLocalizations.page_login_password_forgotten_body;

    isBusy = true;
    setStateIfMounted();

    try {
      await userController.sendPasswordResetEmail(widget.emailAddress);
      ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: Text(snackbarBody)));
    } finally {
      isBusy = false;
      setStateIfMounted();
    }
  }

  void onControllerCreated(TextEditingController controller) {
    passwordController = controller;
  }

  void onFocusNodeCreated(FocusNode focusNode) {
    passwordFocusNode = focusNode;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(DesignColorsModel colors) {
    if (currentPassword.isEmpty) {
      return null;
    }

    return passwordValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(colors);

    final Color tintColor = getTextFieldTintColor(colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: onPasswordConfirmed,
          isDisabled: !isPasswordValid || isBusy,
          label: localizations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(isDisabled: isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_account_verify_account_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_account_verify_account_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmallMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localizations.page_account_verify_account_password_forgotten,
                  style: PositiveButtonStyle.text,
                  size: PositiveButtonSize.small,
                  isDisabled: isBusy,
                  onTapped: () => onPasswordResetSelected(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.page_registration_password_label,
              initialText: currentPassword,
              onTextChanged: onPasswordChanged,
              onTextSubmitted: (str) => onPasswordConfirmed(),
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !isBusy,
              obscureText: true,
              autofocus: true,
              autocorrect: false,
            ),
          ],
        ),
      ],
    );
  }
}
