// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/formatter_helpers.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
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
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfileNameEntryPage extends ConsumerWidget {
  const ProfileNameEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return colors.purple;
    }

    return controller.nameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return null;
    }

    return controller.nameValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(backgroundColor: colors.green);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final Profile? profile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final bool hasNameViolationFlag = profile?.accountFlags.contains(kAccountFlagNameOffensive) ?? false;

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    final bool currentVisibilityFlagStatus = profile?.visibilityFlags.contains(kVisibilityFlagName) ?? false;
    final bool newVisibilityFlagStatus = state.visibilityFlags[kVisibilityFlagName] ?? false;

    final String currentName = profile?.name ?? '';
    final String newName = state.name;
    final String initialName = currentName.isNotEmpty ? currentName : newName;

    final bool isEditing = state.formMode == FormMode.edit;
    final bool hasChanges = isEditing && currentVisibilityFlagStatus != newVisibilityFlagStatus || currentName != newName;

    return PositiveScaffold(
      onWillPopScope: () async => controller.onBackSelected(ProfileNameEntryRoute),
      backgroundColor: colors.colorGray1,
      isBusy: state.isBusy,
      trailingWidgets: <Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(state.visibilityFlags[kVisibilityFlagName] ?? false),
          onTap: controller.onNameVisibilityToggleRequested,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onNameConfirmed,
          isDisabled: !controller.isNameValid || (isEditing && !hasChanges),
          label: isEditing ? localizations.shared_actions_update : localizations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    onTapped: () => controller.onBackSelected(ProfileNameEntryRoute),
                    label: localizations.shared_actions_back,
                    style: PositiveButtonStyle.text,
                    layout: PositiveButtonLayout.textOnly,
                    size: PositiveButtonSize.small,
                  ),
                ),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 5,
                  currentPage: 0,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_name_entry_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_name_entry_description,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.page_profile_name_entry_input_label,
              initialText: initialName,
              onTextChanged: controller.onNameChanged,
              onTextSubmitted: (_) => controller.onNameConfirmed(),
              inputformatters: [removeNumbersFormatter()],
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: kPaddingSmall),
            if (hasNameViolationFlag) ...<Widget>[
              PositiveHint(
                label: localizations.page_profile_name_error_moderation_flagged,
                icon: UniconsLine.exclamation_triangle,
                iconColor: colors.red,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
