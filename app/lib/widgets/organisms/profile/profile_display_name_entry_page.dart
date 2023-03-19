// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class ProfileDisplayNameEntryPage extends ConsumerWidget {
  const ProfileDisplayNameEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.displayName.isEmpty) {
      return colors.purple;
    }

    return controller.displayNameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.displayName.isEmpty) {
      return null;
    }

    return controller.displayNameValidationResults.isNotEmpty ? PositiveTextFieldIcon.error(colors) : PositiveTextFieldIcon.success(colors);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    String errorMessage = localizations.fromValidationErrorList(controller.displayNameValidationResults);
    bool shouldDisplayErrorMessage = state.displayName.isNotEmpty && errorMessage.isNotEmpty;

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
      trailingWidgets: hints,
      footerWidgets: <Widget>[
        //TODO(andy): Add "Display In App" toggle
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onDisplayNameConfirmed,
          isDisabled: !controller.isDisplayNameValid,
          label: localizations.shared_actions_continue,
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
                  onTapped: () => appRouter.navigate(const ProfileNameEntryRoute()),
                  label: localizations.shared_actions_back,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 9,
                  currentPage: 1,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_display_name_entry_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_profile_display_name_entry_description,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.page_profile_display_name_entry_input_label,
              initialText: state.displayName,
              onTextChanged: controller.onDisplayNameChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.name,
            ),
          ],
        ),
      ],
    );
  }
}
