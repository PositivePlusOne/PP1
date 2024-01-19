// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/profile_constants.dart';
import '../../../providers/profiles/profile_form_controller.dart';

@RoutePage()
class ProfileAboutPage extends ConsumerWidget {
  const ProfileAboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final locale = AppLocalizations.of(context)!;

    return PositiveScaffold(
      onWillPopScope: () => ref.read(profileFormControllerProvider.notifier).onBackSelected(ProfileAboutRoute),
      headingWidgets: [
        PositiveBasicSliverList(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(profileFormControllerProvider);
                return Row(
                  children: [
                    PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      onTapped: () => ref.read(profileFormControllerProvider.notifier).onBackSelected(ProfileAboutRoute),
                      label: locale.shared_actions_back,
                      isDisabled: state.isBusy,
                      style: PositiveButtonStyle.text,
                      layout: PositiveButtonLayout.textOnly,
                      size: PositiveButtonSize.small,
                    ),
                    if (state.formMode == FormMode.create)
                      PositivePageIndicator(
                        color: colors.black,
                        pagesNum: 6,
                        currentPage: 5,
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              locale.page_profile_edit_about_you,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              locale.page_profile_edit_about_you_desc,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTextField(
              onTextChanged: (text) {
                ref.read(profileFormControllerProvider.notifier).onBiographyChanged(text);
              },
              initialText: state.biography,
              minLines: 5,
              maxLines: 10,
              showRemaining: true,
              maxLength: kBiographyMaxLength,
              textInputType: TextInputType.multiline,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              labelText: locale.page_profile_edit_about_you,
              tintColor: colors.purple,
            ),
          ],
        ),
      ],
      trailingWidgets: const <Widget>[
        PositiveVisibilityHint(toggleState: PositiveTogglableState.activeForcefully),
        SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: [
        Consumer(
          builder: (context, ref, child) {
            final formState = ref.watch(profileFormControllerProvider);
            final profile = ref.watch(profileControllerProvider);
            final formNotifier = ref.read(profileFormControllerProvider.notifier);
            final isSameAbout = formState.biography == profile.currentProfile?.biography;
            return PositiveButton(
              colors: colors,
              primaryColor: colors.black,
              onTapped: () => formNotifier.onBiographyConfirmed(locale.page_profile_edit_about_you_thanks),
              isDisabled: !formNotifier.isBiographyValid || (isSameAbout && formState.formMode == FormMode.edit),
              label: formState.formMode == FormMode.edit ? locale.shared_actions_update : locale.shared_actions_continue,
            );
          },
        ),
      ],
    );
  }
}
