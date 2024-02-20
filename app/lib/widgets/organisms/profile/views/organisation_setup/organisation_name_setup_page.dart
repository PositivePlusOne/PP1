// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/formatters/lower_case_input_formatter.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/formatter_helpers.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/forms/profile_form_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/atoms/input/positive_text_field_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/views/organisation_setup/constants/organisation_setup_constants.dart';

@RoutePage()
class OrganisationNameSetupPage extends ConsumerWidget {
  const OrganisationNameSetupPage({super.key});

  Color getDisplayNameTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.displayName.isEmpty) {
      return colors.purple;
    }

    return controller.displayNameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  Color getNameTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return colors.purple;
    }

    return controller.nameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getDisplayNameTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.displayName.isEmpty) {
      return null;
    }

    return controller.displayNameValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(
            backgroundColor: colors.green,
            onTap: (context) => controller.onDisplayNameConfirmed(context),
          );
  }

  PositiveTextFieldIcon? getNameTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return null;
    }

    return controller.nameValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  Widget getHint(BuildContext context, ProfileFormController controller, DesignColorsModel colors) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final bool isDisplayNameValid = controller.displayNameValidationResults.isEmpty && controller.state.displayName.isNotEmpty;
    final bool isDisplayNameEmpty = controller.state.displayName.isEmpty;
    final bool isNameValid = controller.nameValidationResults.isEmpty && controller.state.name.isNotEmpty;
    final bool isNameEmpty = controller.state.name.isEmpty;

    if (!isDisplayNameValid && !isNameValid && !isDisplayNameEmpty && !isNameEmpty) {
      String errorMessage = '';
      if (controller.displayNameValidationResults.isNotEmpty) {
        errorMessage = localizations.fromObject(controller.displayNameValidationResults.first);
      } else if (controller.nameValidationResults.isNotEmpty) {
        errorMessage = localizations.fromObject(controller.nameValidationResults.first);
      }

      return PositiveHint.fromError(errorMessage, colors);
    } else {
      return const PositiveVisibilityHint(
        isEnabled: false,
        toggleState: PositiveTogglableState.activeForcefully,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color displayNameTintColor = getDisplayNameTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? displayNameSuffixIcon = getDisplayNameTextFieldSuffixIcon(controller, colors);

    final Color nameTintColor = getNameTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? nameSuffixIcon = getNameTextFieldSuffixIcon(controller, colors);

    return PositiveScaffold(
      onWillPopScope: () async => controller.onBackSelected(ProfileDisplayNameEntryRoute),
      backgroundColor: colors.colorGray1,
      isBusy: state.isBusy,
      trailingWidgets: <Widget>[
        getHint(context, controller, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        Consumer(
          builder: (context, ref, child) {
            final isSameDisplayName = state.displayName == ref.watch(profileControllerProvider).currentProfile?.displayName;
            return PositiveButton(
              colors: colors,
              primaryColor: colors.black,
              onTapped: () => controller.onDisplayNameAndNameConfirmed(context),
              isDisabled: !controller.isDisplayNameValid || (isSameDisplayName && state.formMode == FormMode.edit),
              label: controller.state.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
            );
          },
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  onTapped: () => controller.onBackSelected(OrganisationNameSetupPage),
                  label: localizations.shared_actions_back,
                  isDisabled: true,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                if (state.formMode == FormMode.create)
                  PositivePageIndicator(
                    color: colors.black,
                    pagesNum: kOrganisationSetupTotalSteps,
                    currentPage: 0,
                  ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_organisation_name_title,
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_organisation_name_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localizations.shared_organisation_name,
              initialText: state.name,
              onTextChanged: controller.onNameChanged,
              tintColor: nameTintColor,
              suffixIcon: nameSuffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.text,
              inputformatters: [removeNumbersFormatter()],
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localizations.shared_organisation_display_name,
              initialText: state.displayName,
              onTextChanged: controller.onDisplayNameChanged,
              tintColor: displayNameTintColor,
              suffixIcon: displayNameSuffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.text,
              prefixIcon: const PositiveTextFieldText(
                text: '@',
              ),
              inputformatters: [LowerCaseInputFormatter()],
              textCapitalization: TextCapitalization.none,
            ),
          ],
        ),
      ],
    );
  }
}
