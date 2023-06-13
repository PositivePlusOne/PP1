// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/localization/country.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class RegistrationPhoneEntryPage extends ConsumerWidget {
  const RegistrationPhoneEntryPage({super.key});

  Color getTextFieldPrefixColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return colors.purple;
    }

    return controller.phoneValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return colors.purple;
    }

    return controller.phoneValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return null;
    }

    return controller.phoneValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AccountFormController controller = ref.read(accountFormControllerProvider.notifier);
    final AccountFormState state = ref.watch(accountFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    final String errorMessage = localizations.fromValidationErrorList(controller.phoneValidationResults);
    final bool shouldDisplayErrorMessage = state.phoneNumber.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      if (!shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.visibility(localizations.shared_form_defaults_hidden, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPhoneNumberConfirmed,
          isDisabled: !controller.isPhoneValid || state.isBusy,
          label: localizations.shared_actions_continue,
        ),
      ],
      trailingWidgets: hints,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PositiveBackButton(onBackSelected: controller.onWillPopScope),
                const SizedBox(width: kPaddingSmall),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 6,
                  currentPage: 2,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_your_number,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_registration_verification_code,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localizations.shared_form_information_display,
                  size: PositiveButtonSize.small,
                  style: PositiveButtonStyle.text,
                  padding: PositiveButton.kButtonPaddingTiny,
                  borderWidth: PositiveButton.kButtonBorderWidthHovered,
                  onTapped: () => controller.onPhoneHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.page_registration_phone_number,
              initialText: state.phoneNumber,
              onTextChanged: controller.onPhoneNumberChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.phone,
              prefixIcon: PositiveTextFieldPrefixDropdown<Country>(
                onValueChanged: (dynamic str) => controller.onCountryChanged(str as Country),
                initialValue: kCountryList.firstWhere((element) => element.phoneCode == '44'),
                valueStringBuilder: (value) => '${value.name} (+${value.phoneCode})',
                placeholderStringBuilder: (value) => '+${value.phoneCode}',
                values: kCountryList,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
