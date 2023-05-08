// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_tile.dart';
import '../../../constants/profile_constants.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/prompts/positive_hint.dart';

@RoutePage()
class ProfileBiographyEntryPage extends ConsumerWidget {
  const ProfileBiographyEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.biography.isEmpty) {
      return colors.purple;
    }

    return controller.biographyValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Profile userProfile = ref.watch(profileControllerProvider.select((value) => value.userProfile!));
    final Color textFieldTintColor = getTextFieldTintColor(controller, colors);

    final String errorMessage = localizations.fromValidationErrorList(controller.biographyValidationResults);
    final bool shouldDisplayErrorMessage = state.biography.isNotEmpty && errorMessage.isNotEmpty;

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      backgroundColor: colors.black,
      resizeToAvoidBottomInset: false,
      onWillPopScope: () async => controller.onBackSelected(ProfileBiographyEntryRoute),
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        foregroundColor: colors.white,
        backgroundColor: colors.black,
        safeAreaQueryData: mediaQueryData,
      ),
      headingWidgets: <Widget>[
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: kPaddingMassive,
                    left: kPaddingMedium,
                    right: kPaddingMedium,
                    bottom: kPaddingMedium,
                  ),
                  children: <Widget>[
                    Row(
                      children: [
                        PositiveButton(
                          colors: colors,
                          primaryColor: colors.white,
                          onTapped: () => controller.onBackSelected(ProfileBiographyEntryRoute),
                          isDisabled: state.isBusy,
                          label: localizations.shared_actions_back,
                          style: PositiveButtonStyle.text,
                          layout: PositiveButtonLayout.textOnly,
                          size: PositiveButtonSize.small,
                        ),
                        if (state.formMode != FormMode.edit)
                          PositivePageIndicator(
                            color: colors.white,
                            pagesNum: 9,
                            currentPage: 8,
                          ),
                      ],
                    ),
                    const SizedBox(height: kPaddingLarge),
                    Text(
                      'Pick a colour, this will show on your profile',
                      style: typography.styleSubtitle.copyWith(color: colors.white),
                    ),
                    const SizedBox(height: kPaddingSmall),
                    Wrap(
                      spacing: kPaddingSmall,
                      runSpacing: kPaddingSmall,
                      children: <Widget>[
                        for (final String colorHex in DesignColorsModel.selectableProfileColorStrings) ...<Widget>[
                          AnimatedOpacity(
                            duration: kAnimationDurationRegular,
                            opacity: state.accentColor.isEmpty
                                ? 1.0
                                : state.accentColor == colorHex
                                    ? 1.0
                                    : 0.2,
                            child: PositiveTapBehaviour(
                              isEnabled: !state.isBusy,
                              onTap: () => controller.onAccentColorSelected(colorHex),
                              child: AbsorbPointer(
                                child: PositiveProfileCircularIndicator(
                                  profile: userProfile,
                                  size: kIconMassive,
                                  borderThickness: kBorderThicknessMedium,
                                  ringColorOverride: colorHex.toSafeColorFromHex(defaultColor: colors.teal),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: kPaddingLarge),
                    Text(
                      'Say something about yourself. You can complete this at any time',
                      style: typography.styleSubtitle.copyWith(color: colors.white),
                    ),
                    const SizedBox(height: kPaddingSmall),
                    PositiveTextField(
                      minLines: 5,
                      maxLines: 5,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      maxLength: kBiographyMaxLength,
                      tintColor: textFieldTintColor,
                      isEnabled: !state.isBusy,
                      labelText: localizations.page_profile_edit_about_you,
                      onTextChanged: (str) => controller.onBiographyChanged(str),
                    ),
                    const SizedBox(height: kPaddingSmall),
                    ...hints,
                  ],
                ),
              ),
              Container(
                color: state.accentColor.toSafeColorFromHex(defaultColor: colors.white),
                padding: const EdgeInsets.all(kPaddingSmall),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                      child: PositiveProfileTile(
                        profile: userProfile,
                        metadata: const {
                          'Followers': '1.2M',
                          'Likes': '42k',
                          'Posts': '120',
                        },
                      ),
                    ),
                    const SizedBox(height: kPaddingLarge),
                    PositiveGlassSheet(
                      children: <Widget>[
                        PositiveButton(
                          colors: colors,
                          onTapped: controller.onBiographyAndAccentColorConfirmed,
                          isDisabled: state.accentColor.isEmpty || state.isBusy || shouldDisplayErrorMessage,
                          style: PositiveButtonStyle.primary,
                          primaryColor: colors.black,
                          label: controller.state.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.page_profile_biography_continue,
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQueryData.padding.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
