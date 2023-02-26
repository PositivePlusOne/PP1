// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/providers/user/new_account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/localization/country.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../atoms/input/positive_text_field_dropdown.dart';

class RegistrationPhoneEntryPage extends ConsumerWidget {
  const RegistrationPhoneEntryPage({super.key});

  Color getTextFieldPrefixColor(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return colors.purple;
    }

    return controller.phoneValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  Color getTextFieldTintColor(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return colors.purple;
    }

    return controller.phoneValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return null;
    }

    return controller.phoneValidationResults.isNotEmpty ? PositiveTextFieldIcon.error(colors) : PositiveTextFieldIcon.success(colors);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NewAccountFormController controller = ref.read(newAccountFormControllerProvider.notifier);
    final NewAccountFormState state = ref.watch(newAccountFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    String errorMessage = localizations.fromValidationErrorList(controller.phoneValidationResults);
    bool shouldDisplayErrorMessage = state.phoneNumber.isNotEmpty && errorMessage.isNotEmpty;

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
          onTapped: controller.onPhoneNumberConfirmed,
          isDisabled: !controller.isPhoneValid,
          label: localizations.shared_actions_continue,
        ),
      ],
      children: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositivePageIndicator(
              colors: colors,
              pagesNum: 6,
              currentPage: 2,
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Your Number',
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              'We’ll send you a verification code via text.',
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: 'Phone Number',
              initialText: state.phoneNumber,
              onTextChanged: controller.onPhoneNumberChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.phone,
              prefixIcon: PositiveTextFieldDropdown<Country>(
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
