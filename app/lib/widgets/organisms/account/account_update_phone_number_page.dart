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
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/country_constants.dart';
import '../../../dtos/localization/country.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class AccountUpdatePhoneNumberPage extends ConsumerWidget {
  const AccountUpdatePhoneNumberPage({super.key});

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return colors.purple;
    }

    return controller.isPhoneValid ? colors.green : colors.red;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.phoneNumber.isEmpty) {
      return null;
    }

    return controller.isPhoneValid
        ? PositiveTextFieldIcon.success(backgroundColor: colors.green)
        : PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AccountFormController controller = ref.read(accountFormControllerProvider.notifier);
    final AccountFormState state = ref.watch(accountFormControllerProvider);

    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    final String errorMessage = localisations.fromValidationErrorList(controller.phoneValidationResults);
    final bool shouldDisplayErrorMessage = state.phoneNumber.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      if (!shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.visibility(localisations.shared_form_defaults_hidden, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            const PositiveBackButton(),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_registration_change_number,
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_registration_new_number,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localisations.shared_phone_number,
              initialText: state.phoneNumber,
              onTextChanged: controller.onPhoneNumberChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.phone,
              prefixIcon: PositiveTextFieldPrefixDropdown<Country>(
                onValueChanged: (dynamic str) => controller.onCountryChanged(str as Country),
                //TODO(R): hard coded 44, this seems very very wrong here for a global audiance. Making a severe ticket for this
                initialValue: kCountryList.firstWhere((element) => element.phoneCode == '44'),
                valueStringBuilder: (value) => '${value.name} (+${value.phoneCode})',
                placeholderStringBuilder: (value) => '+${value.phoneCode}',
                values: kCountryList,
              ),
            ),
          ],
        ),
      ],
      trailingWidgets: hints,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onChangePhoneNumberRequested,
          isDisabled: !controller.isPhoneValid || state.isBusy,
          label: controller.state.formMode == FormMode.edit ? localisations.shared_actions_update : localisations.shared_actions_continue,
        ),
      ],
    );
  }
}
