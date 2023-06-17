// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/imagery/positive_focused_place_map_widget.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/shared/animations/positive_expandable_widget.dart';
import '../../../constants/design_constants.dart';
import '../../../gen/app_router.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../atoms/input/positive_text_field.dart';

@RoutePage()
class ProfileLocationPage extends ConsumerStatefulWidget {
  const ProfileLocationPage({super.key});

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

    return PositiveScaffold(
      visibleComponents: PositiveScaffoldComponent.onlyHeadingWidgets,
      resizeToAvoidBottomInset: false,
      onWillPopScope: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)) ? () async => viewModel.onBackSelected(ProfileLocationRoute) : null,
      headingWidgets: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: kPaddingMedium + MediaQuery.of(context).padding.top,
              left: kPaddingMedium,
              right: kPaddingMedium,
              bottom: kPaddingMedium,
            ),
            color: colors.colorGray1,
            child: Column(
              children: [
                PositiveAppBar(
                  backgroundColor: colors.colorGray1,
                  foregroundColor: colors.colorGray1.complimentTextColor,
                ),
                const SizedBox(height: kPaddingMassive),
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
                        if (formMode == FormMode.create)
                          PositivePageIndicator(
                            color: colors.black,
                            pagesNum: 9,
                            currentPage: 6,
                          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PositiveTextField(
                        hintText: 'Search',
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
                        onTextSubmitted: (_) => viewModel.onLocationSearchQuerySubmitted(),
                        suffixIcon: PositiveTextFieldIcon.search(
                          backgroundColor: getTintColor(
                            colors: colors,
                            place: ref.watch(profileFormControllerProvider.select((value) => value.place)),
                            hasFocus: ref.watch(profileFormControllerProvider.select((value) => value.isFocused)),
                            returnTransparentIfNull: false,
                          ),
                          isEnabled: ref.watch(profileFormControllerProvider.select((value) => value.isBusy)),
                          onTap: viewModel.onLocationSearchQuerySubmitted,
                        ),
                      ),
                    ),
                    const SizedBox(width: kPaddingSmall),
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
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: IndexedStack(
            index: ref.watch(profileFormControllerProvider.select((value) => value.hasFailedLocationSearch ? 1 : (value.place?.latitude != null && value.place?.longitude != null ? 2 : 0))),
            children: [
              _ProfileLocationProfilePendingShade(
                colors: colors,
                mediaQuery: mediaQuery,
                localizations: localizations,
                typography: typography,
                ref: ref,
              ),
              _ProfileLocationProfileFailedShade(
                colors: colors,
                mediaQuery: mediaQuery,
                localizations: localizations,
                typography: typography,
                ref: ref,
              ),
              _ProfileLocationProfileDisplayShade(
                colors: colors,
                mediaQuery: mediaQuery,
                localizations: localizations,
                typography: typography,
                ref: ref,
              ),
            ],
          ),
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

    final PositivePlace? place = state.place;
    final bool hasLocation = state.place?.placeId.isNotEmpty ?? false;
    final bool hasNewLocation = hasLocation && state.place?.placeId != profileState.userProfile?.place?.placeId;

    return Stack(
      children: <Widget>[
        PositiveFocusedPlaceMapWidget(place: place ?? PositivePlace.empty()),
        Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PositiveGlassSheet(
                children: <Widget>[
                  PositiveExpandableWidget(
                    collapsedChild: PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      label: 'Remove Location',
                      layout: PositiveButtonLayout.textOnly,
                      style: PositiveButtonStyle.primary,
                      onTapped: controller.onRemoveLocation,
                      isDisabled: state.isBusy,
                    ),
                    expandedChild: PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      label: 'Continue with Location',
                      layout: PositiveButtonLayout.textOnly,
                      style: PositiveButtonStyle.primary,
                      onTapped: controller.onLocationConfirmed,
                      isDisabled: state.isBusy,
                    ),
                    isExpanded: hasNewLocation,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
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
                children: <Widget>[
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    label: 'Continue Without Location',
                    layout: PositiveButtonLayout.textOnly,
                    style: PositiveButtonStyle.primary,
                    onTapped: ref.read(profileFormControllerProvider.notifier).onLocationSkipped,
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
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
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
                      UniconsLine.location_point,
                      color: colors.white,
                      size: kIconLarge,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium),
                        child: Text(
                          localizations.page_profile_location_subtitle,
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
                children: <Widget>[
                  PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    label: 'Continue Without Location',
                    layout: PositiveButtonLayout.textOnly,
                    style: PositiveButtonStyle.primary,
                    onTapped: ref.read(profileFormControllerProvider.notifier).onLocationSkipped,
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
