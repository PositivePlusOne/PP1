// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/input/remove_focus_wrapper.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/maps/profile_map.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/location_view_model.dart';
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
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ProfileFormController profileFormController = ref.read(profileFormControllerProvider.notifier);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return RemoveFocusWrapper(
      child: PositiveScaffold(
        hideBottomPadding: true,
        backgroundColor: colors.purple,
        resizeToAvoidBottomInset: false,
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
                                onTapped: () => formMode == FormMode.edit ? context.router.pop() : ref.read(profileFormControllerProvider.notifier).onBackSelected(ProfileLocationRoute),
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
                        onTapped: () => profileFormController.onLocationHelpRequested(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: kPaddingMedium),
                  Row(
                    children: [
                      const _PlacesSearch(),
                      const SizedBox(width: kPaddingSmall),
                      PositiveButton(
                        colors: colors,
                        primaryColor: colors.black,
                        onTapped: () => ref.read(locationViewModelProvider.notifier).findMyLocation(),
                        size: PositiveButtonSize.medium,
                        label: localizations.page_profile_location_action_find,
                      ),
                    ],
                  ),
                  const SizedBox(height: kPaddingMedium),
                  Consumer(
                    builder: (context, ref, child) => PositiveVisibilityHint(
                      toggleState: PositiveTogglableState.fromBool(ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagLocation] ?? true),
                      onTap: () => ref.read(profileFormControllerProvider.notifier).onLocationVisibilityToggleRequested(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: colors.purple),
                        height: double.infinity,
                        width: double.infinity,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final viewModel = ref.watch(locationViewModelProvider);
                            final hasLocation = viewModel.location != null;
                            if (hasLocation) {
                              return ProfileMap(
                                cameraPosition: viewModel.location!,
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Consumer(
                            builder: (context, ref, child) {
                              final hasLocation = ref.watch(locationViewModelProvider).location != null;
                              if (hasLocation) {
                                return const SizedBox();
                              }
                              return ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 262),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(UniconsLine.location_point, size: 35, color: colors.white),
                                    Text(
                                      localizations.page_profile_location_instruction,
                                      textAlign: TextAlign.center,
                                      style: typography.styleBody.copyWith(color: colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final locationViewModel = ref.watch(locationViewModelProvider);
                                final profileController = ref.watch(profileControllerProvider);
                                final profileFormState = ref.watch(profileFormControllerProvider);

                                final hasSameLocation = _hasSameLocation(locationViewModel, profileController);
                                return PositiveGlassSheet(
                                  children: [
                                    PositiveButton(
                                      colors: colors,
                                      isDisabled: false,
                                      onTapped: () async {
                                        final viewModel = ref.read(locationViewModelProvider);
                                        final location = viewModel.location;
                                        final thanksDesc = localizations.page_profile_thanks_location;
                                        if (hasSameLocation && profileFormState.formMode == FormMode.edit) {
                                          await ref.read(profileFormControllerProvider.notifier).onLocationConfirmed(null, thanksDesc);
                                        } else {
                                          await ref.read(profileFormControllerProvider.notifier).onLocationConfirmed(location, thanksDesc);
                                        }
                                      },
                                      label: _getSubmitLabel(
                                        context: context,
                                        profileFormState: profileFormState,
                                        hasSameLocation: hasSameLocation,
                                        locationState: locationViewModel,
                                      ),
                                      layout: PositiveButtonLayout.textOnly,
                                      style: PositiveButtonStyle.primary,
                                      primaryColor: colors.black,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + kPaddingMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns true if the current location is the same as the one in the profile
  bool _hasSameLocation(
    LocationState locationState,
    ProfileControllerState profileControllerState,
  ) {
    final currentLocation = profileControllerState.userProfile?.location;
    if (currentLocation != null && currentLocation.latitude == locationState.location?.lat && currentLocation.longitude == locationState.location?.lng) {
      return true;
    }
    return false;
  }

  String _getSubmitLabel({
    required BuildContext context,
    required bool hasSameLocation,
    required LocationState locationState,
    required ProfileFormState profileFormState,
  }) {
    final localizations = AppLocalizations.of(context)!;

    if (hasSameLocation && profileFormState.formMode == FormMode.edit) {
      return localizations.page_profile_location_remove;
    }
    return locationState.location != null ? localizations.shared_actions_continue_with_location : localizations.shared_actions_continue_without_location;
  }
}

class _PlacesSearch extends ConsumerStatefulWidget {
  const _PlacesSearch({Key? key}) : super(key: key);

  @override
  _PlacesSearchState createState() => _PlacesSearchState();
}

class _PlacesSearchState extends ConsumerState<_PlacesSearch> {
  TextEditingController? _textEditingController;

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    ref.listen<LocationControllerState>(locationControllerProvider, _locationControllerListener);
    final viewModel = ref.watch(locationViewModelProvider);
    final hasSubmittedQuery = viewModel.location != null && viewModel.searchQuery != null;

    return Expanded(
      child: PositiveTextField(
        onControllerCreated: (controller) => _textEditingController = controller,
        tintColor: hasSubmittedQuery ? colors.green : colors.purple,
        labelText: locale.shared_search_hint,
        onTextSubmitted: _handleSearch,
        onTextChanged: (value) => ref.read(locationViewModelProvider.notifier).updateSearchQuery(value),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(kPaddingExtraSmall),
          child: SizedBox(
            child: PositiveButton(
              layout: PositiveButtonLayout.iconOnly,
              size: PositiveButtonSize.small,
              onTapped: () {
                if (_textEditingController != null) {
                  _handleSearch(_textEditingController!.text);
                }
              },
              iconWidgetBuilder: (primaryColor) {
                if (hasSubmittedQuery) {
                  return Icon(UniconsLine.check, color: colors.white, size: 20);
                }
                return Icon(UniconsLine.search, color: primaryColor, size: 20);
              },
              primaryColor: hasSubmittedQuery ? colors.green : colors.black,
              colors: colors,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSearch(String query) async {
    final locationController = ref.read(locationControllerProvider.notifier);
    locationController.searchLocation(query);
  }

  Future<void> _locationControllerListener(
    LocationControllerState? previous,
    LocationControllerState next,
  ) async {
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    if (previous?.selectedPlace != next.selectedPlace && next.selectedPlace != null && next.selectedPlace!.geometry != null) {
      ref.read(locationViewModelProvider.notifier).setLocation(location: next.selectedPlace!.geometry!.location);
    }
    if (next.placesList != null && next.placesList != previous?.placesList) {
      final places = next.placesList!;
      LocationOption? selectedPlace = places.first;
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          final locale = AppLocalizations.of(context)!;
          return Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PositiveButton(
                        style: PositiveButtonStyle.text,
                        label: locale.shared_actions_cancel,
                        colors: colors,
                        onTapped: () {
                          selectedPlace = null;
                          Navigator.of(context).pop();
                        },
                      ),
                      PositiveButton(
                        style: PositiveButtonStyle.text,
                        label: locale.shared_actions_done,
                        colors: colors,
                        onTapped: () {
                          if (selectedPlace != null) {
                            ref.read(locationControllerProvider.notifier).getLocationByPlaceId(selectedPlace!.placeId);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      squeeze: 1.45,
                      useMagnifier: false,
                      diameterRatio: 1.5,

                      itemExtent: 32,

                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        selectedPlace = places[selectedItem];
                      },
                      children: places
                          .map(
                            (place) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  place.description,
                                  style: typography.styleBody,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
