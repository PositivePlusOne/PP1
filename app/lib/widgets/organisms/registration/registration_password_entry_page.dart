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
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class RegistrationPasswordEntryPage extends ConsumerWidget {
  const RegistrationPasswordEntryPage({super.key});

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

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
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
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPasswordConfirmed,
          isDisabled: !controller.isPasswordValid,
          label: localizations.shared_actions_continue,
        ),
      ],
      trailingWidgets: hints,
      headingWidgets: <Widget>[
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PositiveBackButton(isDisabled: state.isBusy),
                    const SizedBox(width: kPaddingSmall),
                    PositivePageIndicator(
                      color: colors.black,
                      pagesNum: 6,
                      currentPage: 1,
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_registration_create_password,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingSmall),
                Text(
                  localizations.page_registration_create_password_tooltip,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingLarge),
                PositiveTextField(
                  labelText: localizations.page_registration_password_label,
                  initialText: state.password,
                  onTextChanged: controller.onPasswordChanged,
                  onTextSubmitted: (_) => controller.onPasswordConfirmed(),
                  tintColor: tintColor,
                  suffixIcon: suffixIcon,
                  isEnabled: !state.isBusy,
                  obscureText: true,
                  autofocus: true,
                  autocorrect: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
