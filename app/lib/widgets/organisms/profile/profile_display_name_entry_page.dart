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
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/formatter_helpers.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

@RoutePage()
class ProfileDisplayNameEntryPage extends ConsumerWidget {
  const ProfileDisplayNameEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.displayName.isEmpty) {
      return colors.purple;
    }

    return controller.displayNameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors, String thanksString) {
    if (controller.state.displayName.isEmpty) {
      return null;
    }

    return controller.displayNameValidationResults.isNotEmpty
        ? PositiveTextFieldIcon.error(
            backgroundColor: colors.red,
          )
        : PositiveTextFieldIcon.success(
            backgroundColor: colors.green,
            onTap: (context) => controller.onDisplayNameConfirmed(context, thanksString),
          );
  }

  Widget getHint(BuildContext context, ProfileFormController controller, DesignColorsModel colors) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    if (controller.displayNameValidationResults.isNotEmpty && controller.state.displayName.isNotEmpty) {
      final String errorMessage = localizations.fromObject(controller.displayNameValidationResults.first);
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

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors, localizations.page_profile_thanks_display_name);

    return PositiveScaffold(
      onWillPopScope: () async => controller.onBackSelected(ProfileDisplayNameEntryRoute),
      backgroundColor: colors.colorGray1,
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
              onTapped: () => controller.onDisplayNameConfirmed(context, localizations.page_profile_thanks_display_name),
              isDisabled: !controller.isDisplayNameValid || (isSameDisplayName && state.formMode == FormMode.edit),
              label: controller.state.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
            );
          },
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(profileFormControllerProvider);
                return Row(
                  children: [
                    PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      onTapped: () => controller.onBackSelected(ProfileDisplayNameEntryRoute),
                      label: localizations.shared_actions_back,
                      isDisabled: state.isBusy,
                      style: PositiveButtonStyle.text,
                      layout: PositiveButtonLayout.textOnly,
                      size: PositiveButtonSize.small,
                    ),
                    if (state.formMode == FormMode.create)
                      PositivePageIndicator(
                        color: colors.black,
                        pagesNum: 9,
                        currentPage: 1,
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.shared_profile_display_name,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_profile_display_name_entry_description,
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
                  onTapped: () => controller.onDisplayNameHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.shared_profile_display_name,
              initialText: state.displayName,
              onTextChanged: controller.onDisplayNameChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.text,
            ),
          ],
        ),
      ],
    );
  }
}
