// Flutter imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:unicons/unicons.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/prompts/positive_visibility_hint.dart';

@RoutePage()
class AccountUpdateNamePage extends ConsumerWidget {
  const AccountUpdateNamePage({super.key});

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return colors.purple;
    }

    return controller.nameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(AccountFormController controller, DesignColorsModel colors) {
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

    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final Locale locale = Localizations.localeOf(context);
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);
    final AccountFormState state = ref.watch(provider);

    final Profile? profile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final bool hasNameViolationFlag = profile?.accountFlags.contains(kAccountFlagNameOffensive) ?? false;

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    return PositiveScaffold(
      isBusy: state.isBusy,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onChangeNameRequested,
          isDisabled: !controller.isNameValid || state.isBusy || (!controller.isNameChanged && !controller.isNameVisibilityChanged),
          label: controller.state.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
        ),
      ],
      trailingWidgets: <Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(state.visibilityFlags[kVisibilityFlagName] ?? false),
          onTap: controller.onNameVisibilityToggleRequested,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_actions_change_name_title,
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_actions_change_name_body,
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
                  onTapped: () => controller.onNameHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              labelText: localisations.page_profile_name_entry_input_label,
              initialText: state.name,
              onTextChanged: controller.onNameChanged,
              textInputType: TextInputType.name,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
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
