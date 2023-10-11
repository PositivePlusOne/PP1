// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
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
import '../../behaviours/positive_tap_behaviour.dart';
import '../../molecules/prompts/positive_visibility_hint.dart';

@RoutePage()
class ProfileBirthdayEntryPage extends ConsumerWidget {
  const ProfileBirthdayEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.birthday.isEmpty) {
      return colors.purple;
    }

    return controller.birthdayValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.birthday.isEmpty) {
      return PositiveTextFieldIcon.calender(
        backgroundColor: colors.black,
      );
    }

    return controller.birthdayValidationResults.isNotEmpty
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

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      onWillPopScope: () async => controller.onBackSelected(ProfileBirthdayEntryRoute),
      trailingWidgets: <Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(state.visibilityFlags[kVisibilityFlagBirthday] ?? false),
          onTap: controller.onBirthdayVisibilityToggleRequested,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onBirthdayConfirmed,
          isDisabled: state.birthday.isEmpty,
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
                  onTapped: () => controller.onBackSelected(ProfileBirthdayEntryRoute),
                  isDisabled: state.isBusy,
                  label: localizations.shared_actions_back,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 6,
                  currentPage: 2,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_birthday_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_profile_birthday_description,
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
                  onTapped: () => controller.onBirthdayHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            Column(
              children: [
                PositiveTapBehaviour(
                  onTap: (context) => controller.onChangeBirthdayRequested(context),
                  child: AbsorbPointer(
                    child: PositiveTextField(
                      labelText: localizations.page_profile_birthday_input_label,
                      initialText: state.birthday.asDateString,
                      onControllerCreated: controller.onBirthdayTextControllerCreated,
                      onTextChanged: (_) {},
                      tintColor: tintColor,
                      suffixIcon: suffixIcon,
                    ),
                  ),
                ),
                if (state.birthday != "" && controller.isUnder13) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: kPaddingSmall),
                    child: PositiveHint.fromInfo(localizations.page_profile_birthday_under_13_error, colors.red),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
