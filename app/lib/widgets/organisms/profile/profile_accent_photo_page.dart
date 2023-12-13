// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_tile.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_photo_dialog.dart';
import 'package:app/widgets/organisms/shared/animations/positive_expandable_widget.dart';

@RoutePage()
class ProfileAccentPhotoPage extends HookConsumerWidget {
  const ProfileAccentPhotoPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.biography.isEmpty) {
      return colors.purple;
    }

    return controller.biographyValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalisations localisations = AppLocalisations.of(context)!;

    final Profile currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile ?? Profile.empty()));
    final String profileId = currentProfile.flMeta?.id ?? '';

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String expectedStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: profileId);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final ProfileStatistics? profileStatistics = cacheController.get<ProfileStatistics>(expectedStatisticsKey);
    final Map<String, String> profileStatisticsData = ProfileStatistics.getDisplayItems(profileStatistics, localisations);

    final Color currentAccentColor = currentProfile.accentColor.toSafeColorFromHex(defaultColor: colors.white);
    final Color accentColor = state.accentColor.toSafeColorFromHex(defaultColor: colors.white);
    final bool hasAccentColorChanged = currentAccentColor != accentColor;
    final bool hasImageChanged = state.newProfileImage != null && state.newProfileImage!.path.isNotEmpty;

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [profileStatistics]).toList();
    useCacheHook(keys: expectedCacheKeys);

    return PositiveScaffold(
      backgroundColor: colors.black,
      decorationColor: accentColor,
      extendBody: false,
      visibleComponents: const {PositiveScaffoldComponent.headingWidgets},
      onWillPopScope: () async => controller.onBackSelected(ProfileAccentPhotoRoute),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          foregroundColor: colors.white,
          backgroundColor: colors.black,
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: kPaddingVerySmall,
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
                    onTapped: () => controller.onBackSelected(ProfileAccentPhotoRoute),
                    isDisabled: state.isBusy,
                    label: localisations.shared_actions_back,
                    style: PositiveButtonStyle.text,
                    layout: PositiveButtonLayout.textOnly,
                    size: PositiveButtonSize.small,
                  ),
                  // PositivePageIndicator(
                  //   color: colors.white,
                  //   pagesNum: 2,
                  //   currentPage: 0,
                  // ),
                ],
              ),
              const SizedBox(height: kPaddingExtraLarge),
              Text(
                localisations.page_registration_accent_photo_body,
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
                          ? kOpacityFull
                          : state.accentColor == colorHex
                              ? kOpacityFull
                              : kOpacityQuarter,
                      child: PositiveTapBehaviour(
                        isEnabled: !state.isBusy,
                        onTap: (_) => controller.onAccentColorSelected(colorHex),
                        child: AbsorbPointer(
                          child: PositiveProfileCircularIndicator(
                            profile: currentProfile,
                            size: kIconMassive,
                            borderThickness: kBorderThicknessMedium,
                            ringColorOverride: colorHex.toSafeColorFromHex(defaultColor: colors.teal),
                            imageOverridePath: state.newProfileImage?.path ?? "",
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
          child: AnimatedContainer(
            duration: kAnimationDurationRegular,
            color: accentColor,
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                PositiveProfileTile(
                  profile: currentProfile,
                  imageOverridePath: state.newProfileImage?.path ?? "",
                  metadata: profileStatisticsData,
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
                            label: state.isBusy ? localisations.shared_actions_uploading : localisations.page_registration_accent_photo_change,
                            onTapped: () => PositiveDialog.show(
                              title: 'Photo options',
                              context: context,
                              child: ProfilePhotoDialog(
                                onCameraSelected: () => controller.onChangeImageFromCameraSelected(context),
                                onImagePickerSelected: () => controller.onChangeImageFromPickerSelected(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: kPaddingMedium),
                          PositiveButton(
                            colors: colors,
                            onTapped: controller.onAccentColorConfirmed,
                            isDisabled: (!hasAccentColorChanged && !hasImageChanged) || state.isBusy,
                            style: PositiveButtonStyle.primary,
                            primaryColor: colors.black,
                            label: state.isBusy ? localisations.shared_actions_updating : localisations.page_registration_accent_photo_update,
                          ),
                        ],
                      ),
                      expandedChild: PositiveButton(
                        colors: colors,
                        onTapped: () {},
                        isDisabled: true,
                        style: PositiveButtonStyle.primary,
                        primaryColor: colors.black,
                        label: localisations.shared_actions_updating,
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
