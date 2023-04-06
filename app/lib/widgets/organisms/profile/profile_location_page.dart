// Flutter imports:
import 'dart:async';

import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/input/remove_focus_wrapper.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/maps/profile_map.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/organisms/profile/vms/location_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../atoms/input/positive_text_field.dart';

class ProfileLocationPage extends ConsumerStatefulWidget {
  const ProfileLocationPage({super.key});

  @override
  ConsumerState<ProfileLocationPage> createState() => _ProfileLocationPageState();
}

class _ProfileLocationPageState extends ConsumerState<ProfileLocationPage> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ProfileFormController profileFormController = ref.read(profileFormControllerProvider.notifier);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return RemoveFocusWrapper(
      child: PositiveScaffold(
        resizeToAvoidBottomInset: false,
        headingWidgets: <Widget>[
          PositiveBasicSliverList(
            children: [
              Row(
                children: [
                  PositiveButton(
                    colors: colors,
                    onTapped: () => Navigator.of(context).pop(),
                    label: localizations.shared_actions_back,
                    primaryColor: colors.black,
                    style: PositiveButtonStyle.text,
                    layout: PositiveButtonLayout.textOnly,
                    size: PositiveButtonSize.small,
                  ),
                  PositivePageIndicator(
                    colors: colors,
                    pagesNum: 9,
                    currentPage: 6,
                  ),
                ],
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
                    onTapped: () => profileFormController.onInterestsHelpRequested(context),
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
                    onTapped: () async {},
                    size: PositiveButtonSize.medium,
                    label: localizations.page_profile_location_action_find,
                  ),
                ],
              ),
              const SizedBox(height: kPaddingMedium),
              Consumer(
                builder: (context, ref, child) => PositiveVisibilityHint(
                  toggleState: PositiveTogglableState.fromBool(false),
                  onTap: () {},
                ),
              ),
            ],
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
                                initialCameraPosition: viewModel.location!,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller = controller;
                                },
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
                            child: PositiveGlassSheet(
                              children: [
                                PositiveButton(
                                  colors: colors,
                                  isDisabled: false,
                                  // TODO(Dan): update user profile
                                  onTapped: () async {},
                                  label: localizations.shared_actions_continue,
                                  layout: PositiveButtonLayout.textOnly,
                                  style: PositiveButtonStyle.primary,
                                  primaryColor: colors.black,
                                ),
                              ],
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
    return Expanded(
      child: PositiveTextField(
        onControllerCreated: (controller) => _textEditingController = controller,
        tintColor: colors.purple,
        labelText: locale.shared_search_hint,
        onTextSubmitted: _handleSearch,
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
              icon: UniconsLine.search,
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
    if (next.placesList != null && next.placesList != previous?.placesList) {
      final places = next.placesList!;
      PlacesSearchResult selectedPlace = places.first;
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
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
            child: CupertinoPicker(
              squeeze: 1,
              useMagnifier: false,
              itemExtent: 32,

              // This is called when selected item is changed.
              onSelectedItemChanged: (int selectedItem) {
                selectedPlace = places[selectedItem];
              },
              children: places
                  .map(
                    (place) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.formattedAddress ?? place.name,
                            style: typography.styleBody,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
      if (selectedPlace.geometry?.location != null) {
        ref.read(locationViewModelProvider.notifier).setLocation(location: selectedPlace.geometry!.location);
      }
    }
  }
}
