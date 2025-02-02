// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/imagery/positive_focused_place_map_widget.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/shared/animations/positive_expandable_widget.dart';

@RoutePage()
class ProfileLocationPage extends ConsumerStatefulWidget {
  const ProfileLocationPage({
    super.key,
  });

  @override
  ConsumerState<ProfileLocationPage> createState() => _ProfileLocationPageState();
}

class _ProfileLocationPageState extends ConsumerState<ProfileLocationPage> {
  Color getTintColor({
    PositivePlace? place,
    required DesignColorsModel colors,
    bool hasFocus = false,
    bool returnTransparentIfNull = false,
  }) {
    if (place != null && place.latitude != null && place.longitude != null) {
      return colors.green;
    }

    if (hasFocus) {
      return colors.purple;
    }

    return returnTransparentIfNull ? Colors.transparent : colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ProfileFormController viewModel = ref.read(profileFormControllerProvider.notifier);

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final int currentPageIndex = ref.watch(
      profileFormControllerProvider.select(
        (value) => value.hasFailedLocationSearch
            ? 1
            : (value.place?.placeId.isNotEmpty ?? false)
                ? 2
                : 0,
      ),
    );

    return PositiveScaffold(
      visibleComponents: PositiveScaffoldComponent.onlyHeadingWidgets,
      resizeToAvoidBottomInset: false,
      onWillPopScope: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)) ? () async => viewModel.onBackSelected(ProfileLocationRoute) : null,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                final formMode = ref.watch(profileFormControllerProvider).formMode;
                return Row(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(profileFormControllerProvider);
                        return PositiveButton(
                          colors: colors,
                          onTapped: () => viewModel.onBackSelected(ProfileLocationRoute),
                          label: localizations.shared_actions_back,
                          isDisabled: state.isBusy,
                          primaryColor: colors.black,
                          style: PositiveButtonStyle.text,
                          layout: PositiveButtonLayout.textOnly,
                          size: PositiveButtonSize.small,
                        );
                      },
                    ),
                    if (formMode == FormMode.create) ...<Widget>[
                      PositivePageIndicator(
                        color: colors.black,
                        pagesNum: 6,
                        currentPage: 5,
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_location_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_location_subtitle,
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
                  onTapped: () => viewModel.onLocationHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PositiveTextField(
                    hintText: localizations.shared_search_hint,
                    initialText: ref.read(profileFormControllerProvider.select((value) => value.place?.description ?? '')),
                    isEnabled: !ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
                    textInputAction: TextInputAction.search,
                    onFocusedChanged: viewModel.onFocusedChanged,
                    tintColor: getTintColor(
                      colors: colors,
                      place: ref.watch(profileFormControllerProvider.select((value) => value.place)),
                      hasFocus: ref.watch(profileFormControllerProvider.select((value) => value.isFocused)),
                      returnTransparentIfNull: true,
                    ),
                    onTextChanged: viewModel.onLocationSearchQueryChanged,
                    onControllerCreated: viewModel.onLocationSearchQueryControllerChanged,
                    onTextSubmitted: (_) => viewModel.onLocationSearchQuerySubmitted(context),
                    suffixIcon: PositiveTextFieldIcon.search(
                      backgroundColor: getTintColor(
                        colors: colors,
                        place: ref.watch(profileFormControllerProvider.select((value) => value.place)),
                        hasFocus: ref.watch(profileFormControllerProvider.select((value) => value.isFocused)),
                        returnTransparentIfNull: false,
                      ),
                      isEnabled: !ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
                      onTap: viewModel.onLocationSearchQuerySubmitted,
                    ),
                  ),
                ),
                const SizedBox(width: kPaddingMedium),
                Align(
                  alignment: Alignment.centerRight,
                  child: PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    isDisabled: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
                    onTapped: ref.read(profileFormControllerProvider.notifier).onAutoFindLocation,
                    size: PositiveButtonSize.medium,
                    label: localizations.page_profile_location_action_find,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveVisibilityHint(
              toggleState: PositiveTogglableState.fromBool(ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagLocation] ?? true),
              onTap: viewModel.onLocationVisibilityToggleRequested,
              isEnabled: !ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
        SliverStack(
          insetOnOverlap: true,
          children: [
            if (currentPageIndex == 2)
              SliverFillRemaining(
                fillOverscroll: false,
                child: PositiveFocusedPlaceMapWidget(
                  place: ref.watch(profileFormControllerProvider.select((value) => value.place ?? PositivePlace.empty())),
                ),
              ),
            // Failsafe sliver so the render tree doesn't explode
            if (currentPageIndex == 0)
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: _ProfileLocationProfilePendingShade(
                  colors: colors,
                  mediaQuery: mediaQuery,
                  localizations: localizations,
                  typography: typography,
                  ref: ref,
                ),
              ),
            if (currentPageIndex == 1)
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: _ProfileLocationProfileFailedShade(
                  colors: colors,
                  mediaQuery: mediaQuery,
                  localizations: localizations,
                  typography: typography,
                  ref: ref,
                ),
              ),
            if (currentPageIndex == 2)
              SliverFillRemaining(
                child: _ProfileLocationProfileDisplayShade(
                  colors: colors,
                  mediaQuery: mediaQuery,
                  localizations: localizations,
                  typography: typography,
                  ref: ref,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProfileLocationProfileDisplayShade extends StatelessWidget {
  const _ProfileLocationProfileDisplayShade({
    required this.colors,
    required this.mediaQuery,
    required this.localizations,
    required this.typography,
    required this.ref,
  });

  final DesignColorsModel colors;
  final MediaQueryData mediaQuery;
  final AppLocalizations localizations;
  final DesignTypographyModel typography;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final ProfileFormController controller = ref.watch(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final bool hasLocation = state.place?.placeId.isNotEmpty ?? false;
    final bool hasDifferentDescription = hasLocation && state.locationSearchQuery != profileState.currentProfile?.place?.description;
    final bool hasNewLocation = hasLocation && state.place?.placeId != profileState.currentProfile?.place?.placeId;

    final bool hasVisibilityFlag = profileState.currentProfile?.visibilityFlags.contains(kVisibilityFlagLocation) ?? false;
    final bool hasDifferentVisibilityFlags = hasLocation && state.visibilityFlags[kVisibilityFlagLocation] != hasVisibilityFlag;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + kPaddingMedium,
          left: kPaddingMedium,
          right: kPaddingMedium,
        ),
        child: PositiveGlassSheet(
          excludeBlur: true,
          children: <Widget>[
            PositiveExpandableWidget(
              isExpanded: hasNewLocation || hasDifferentDescription || hasDifferentVisibilityFlags,
              collapsedChild: PositiveButton(
                colors: colors,
                primaryColor: colors.black,
                label: localizations.page_profile_location_remove,
                layout: PositiveButtonLayout.textOnly,
                style: PositiveButtonStyle.primary,
                onTapped: controller.onRemoveLocation,
                isDisabled: state.isBusy,
              ),
              expandedChild: PositiveButton(
                colors: colors,
                primaryColor: colors.black,
                label: localizations.shared_actions_continue_with_location,
                layout: PositiveButtonLayout.textOnly,
                style: PositiveButtonStyle.primary,
                onTapped: controller.onLocationConfirmed,
                isDisabled: state.isBusy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLocationProfileFailedShade extends StatelessWidget {
  const _ProfileLocationProfileFailedShade({
    required this.colors,
    required this.mediaQuery,
    required this.localizations,
    required this.typography,
    required this.ref,
  });

  final DesignColorsModel colors;
  final MediaQueryData mediaQuery;
  final AppLocalizations localizations;
  final DesignTypographyModel typography;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.yellow,
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom + kPaddingMedium,
        left: kPaddingMedium,
        right: kPaddingMedium,
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      UniconsLine.map_marker_question,
                      color: colors.black,
                      size: kIconLarge,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium),
                        child: Text(
                          localizations.page_profile_location_errors_search_failed,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: typography.styleSubtitle.copyWith(color: colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PositiveGlassSheet(
                excludeBlur: true,
                children: <Widget>[
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    label: localizations.shared_actions_continue_without_location,
                    layout: PositiveButtonLayout.textOnly,
                    style: PositiveButtonStyle.primary,
                    onTapped: () => ref.read(profileFormControllerProvider.notifier).onLocationSkipped(removeLocation: true),
                    isDisabled: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileLocationProfilePendingShade extends StatelessWidget {
  const _ProfileLocationProfilePendingShade({
    required this.colors,
    required this.mediaQuery,
    required this.localizations,
    required this.typography,
    required this.ref,
  });

  final DesignColorsModel colors;
  final MediaQueryData mediaQuery;
  final AppLocalizations localizations;
  final DesignTypographyModel typography;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.purple,
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom + kPaddingMedium,
        left: kPaddingMedium,
        right: kPaddingMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  UniconsLine.location_point,
                  color: colors.white,
                  size: kIconLarge,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium),
                    child: Text(
                      localizations.page_profile_location_instruction,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: typography.styleSubtitle.copyWith(color: colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PositiveGlassSheet(
            excludeBlur: true,
            children: <Widget>[
              PositiveButton(
                colors: colors,
                primaryColor: colors.black,
                label: localizations.shared_actions_continue_without_location,
                layout: PositiveButtonLayout.textOnly,
                style: PositiveButtonStyle.primary,
                onTapped: () => ref.read(profileFormControllerProvider.notifier).onLocationSkipped(removeLocation: true),
                isDisabled: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
