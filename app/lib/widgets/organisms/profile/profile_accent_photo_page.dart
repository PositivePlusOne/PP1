// Flutter imports:
import 'package:flutter/widgets.dart';

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
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_tile.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_photo_dialog.dart';
import 'package:app/widgets/organisms/shared/animations/positive_expandable_widget.dart';

@RoutePage()
class ProfileAccentPhotoPage extends ConsumerWidget {
  const ProfileAccentPhotoPage({super.key});

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

    final Profile userProfile = ref.watch(profileControllerProvider.select((value) => value.userProfile ?? Profile.empty()));

    final Color currentAccentColor = userProfile.accentColor.toSafeColorFromHex(defaultColor: colors.white);
    final Color accentColor = state.accentColor.toSafeColorFromHex(defaultColor: colors.white);
    final bool hasAccentColorChanged = currentAccentColor != accentColor;

    return PositiveScaffold(
      backgroundColor: colors.black,
      footerBackgroundColor: accentColor,
      extendBody: false,
      visibleComponents: const {PositiveScaffoldComponent.headingWidgets},
      onWillPopScope: () async => controller.onBackSelected(ProfileBiographyEntryRoute),
      headingWidgets: <Widget>[
        StickyPositiveAppBar(
          foregroundColor: colors.white,
          backgroundColor: colors.black,
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: kPaddingMassive,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.white,
                    onTapped: () => controller.onBackSelected(ProfileAccentPhotoPage),
                    isDisabled: state.isBusy,
                    label: localizations.shared_actions_back,
                    style: PositiveButtonStyle.text,
                    layout: PositiveButtonLayout.textOnly,
                    size: PositiveButtonSize.small,
                  ),
                  PositivePageIndicator(
                    color: colors.white,
                    pagesNum: 2,
                    currentPage: 0,
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
              const SizedBox(height: kPaddingExtraLarge),
            ]),
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Container(
            color: accentColor,
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                PositiveProfileTile(
                  profile: userProfile,
                  metadata: const {
                    'Followers': '1.2M',
                    'Likes': '42k',
                    'Posts': '120',
                  },
                ),
                const Spacer(),
                const SizedBox(height: kPaddingMedium),
                PositiveGlassSheet(
                  children: <Widget>[
                    PositiveExpandableWidget(
                      collapsedChild: Column(
                        children: <Widget>[
                          PositiveButton(
                            colors: colors,
                            primaryColor: colors.black,
                            isDisabled: state.isBusy,
                            label: state.isBusy ? localizations.shared_actions_uploading : localizations.page_profile_photo_continue,
                            onTapped: () => PositiveDialog.show(
                              context: context,
                              dialog: ProfilePhotoDialog(
                                onCameraSelected: () => controller.onChangeImageFromCameraSelected(context),
                                onImagePickerSelected: () => controller.onChangeImageFromPickerSelected(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: kPaddingMedium),
                          PositiveButton(
                            colors: colors,
                            onTapped: controller.onAccentColorConfirmed,
                            isDisabled: state.accentColor.isEmpty || state.isBusy || !hasAccentColorChanged,
                            style: PositiveButtonStyle.primary,
                            primaryColor: colors.black,
                            label: state.isBusy ? localizations.shared_actions_updating : 'Update Profile',
                          ),
                        ],
                      ),
                      expandedChild: PositiveButton(
                        colors: colors,
                        onTapped: () {},
                        isDisabled: true,
                        style: PositiveButtonStyle.primary,
                        primaryColor: colors.black,
                        label: localizations.shared_actions_updating,
                      ),
                      isExpanded: state.isBusy,
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),
                SizedBox(height: mediaQueryData.padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
