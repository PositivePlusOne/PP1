// Flutter imports:
import 'dart:async';

import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/input/remove_focus_wrapper.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class ProfileLocationPage extends ConsumerStatefulWidget {
  const ProfileLocationPage({super.key});

  @override
  _ProfileLocationPageState createState() => _ProfileLocationPageState();
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
              const SizedBox(height: kPaddingMassive),
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
                  Expanded(
                    child: PositiveTextField(
                      tintColor: colors.purple,
                      //TODO(Dan): the localization for this is already done in pp1-260. Use that.
                      labelText: "search",
                      suffixIcon: Container(
                        height: 34,
                        width: 34,
                        margin: const EdgeInsets.all(kPaddingExtraSmall),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.black,
                        ),
                        child: Icon(
                          UniconsLine.search,
                          color: colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
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
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                // Consumer(
                //   builder: (context, ref, child) => DisplayInApp(
                //     isChecked: true,
                //     onTapped: () async {},
                //   ),
                // ),
                const SizedBox(height: 12),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: colors.purple),
                        height: double.infinity,
                        width: double.infinity,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) async {
                            _controller = controller;
                            final style = await rootBundle.loadString("assets/maps/style.json");
                            _controller!.setMapStyle(style);
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          ConstrainedBox(
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
