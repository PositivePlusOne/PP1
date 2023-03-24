// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_fake_text_field_button.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/organisms/profile/profile_edit/vms/profile_edit_settings_model.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../providers/enuumerations/positive_togglable_state.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../atoms/indicators/positive_profile_image_indicator.dart';
import '../../../molecules/containers/positive_transparent_sheet.dart';
import '../../../molecules/scaffolds/positive_scaffold.dart';

class ProfileEditSettingsPage extends ConsumerWidget {
  const ProfileEditSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final AppRouter appRouter = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final ProfileEditSettingsViewModel viewModel = ref.read(profileEditSettingsViewModelProvider.notifier);
    final ProfileEditSettingsViewModelState viewModelState = ref.watch(profileEditSettingsViewModelProvider);

    //TODO make profile guard
    final UserProfile profile = ref.watch(profileControllerProvider.select((value) => value.userProfile!));

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium + mediaQueryData.padding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Header: Back, Account, and Notifications buttons -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.angle_left,
                      onTapped: () => appRouter.removeLast(),
                    ),
                    const Spacer(),
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.bell,
                      onTapped: viewModel.onToggleNotifications,
                    ),
                    const SizedBox(width: kPaddingSmall),
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.user,
                      primaryColor: colors.colorGray3,
                      style: PositiveButtonStyle.primary,
                      onTapped: viewModel.onAccount,
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingLarge),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                //* -=-=-=-=-=- Title: Profile, Profile image -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localizations.shared_profile_title,
                      style: typography.styleSuperSize,
                    ),
                    const Spacer(),
                    PositiveProfileImageIndicator(
                      userProfile: profile,
                      size: kIconHuge,
                      icon: UniconsLine.camera_change,
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Display Name -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveFakeTextFieldButton.profile(
                  hintText: localizations.shared_profile_display_name,
                  labelText: profile.name,
                  onTap: viewModel.onDisplayName,
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                //* -=-=-=-=-=- About You subheading and text -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\P
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizations.page_profile_edit_about_you,
                          style: typography.styleBold,
                        ),
                        const Spacer(),
                        PositiveButton.appBarIcon(
                          colors: colors,
                          icon: UniconsLine.angle_right,
                          primaryColor: colors.purple,
                          style: PositiveButtonStyle.primary,
                          onTapped: viewModel.onUpdateAboutYou,
                        ),
                      ],
                    ),
                    Text(
                      //TODO replace with bio
                      "test bio",
                      style: typography.styleSubtitle,
                    ),
                    const PositiveVisibilityHint(toggleState: PositiveTogglableState.alwaysActive),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                //* -=-=-=-=-=- Date of Birth -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    PositiveFakeTextFieldButton(
                      hintText: localizations.page_profile_edit_dob,
                      //TODO replace with Date of Birth
                      labelText: "profile.dateOfBirth",
                      //? empty onTap, users may not update date of birth in app
                      backgroundColor: colors.transparent,
                      onTap: () {},
                    ),
                    RichText(
                      text: TextSpan(
                        text: localizations.page_profile_edit_change_details,
                        style: typography.styleSubtitle.copyWith(color: colors.colorGray1.complimentTextColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: localizations.page_profile_edit_change_details_link,
                            style: typography.styleBold.copyWith(
                              color: colors.linkBlue,
                            ),
                          )
                        ],
                      ),
                    ),
                    const PositiveVisibilityHint(toggleState: PositiveTogglableState.active),
                    // PositiveVisibilityHint(toggleState: viewModelState.toggleStateDateOfBirth),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Gender -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_gender,
                      //TODO replace with gender
                      labelText: "profile.gender",
                      onTap: viewModel.onGenderUpdate,
                    ),
                    PositiveVisibilityHint(toggleState: viewModelState.toggleStateGender),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- HIV Status -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_hiv_status,
                      //TODO replace with hiv status
                      labelText: "profile.HIVStatus",
                      onTap: viewModel.onHIVStatusUpdate,
                    ),
                    PositiveVisibilityHint(toggleState: viewModelState.toggleStateHIVStatus),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Location -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_location,
                      //TODO replace with location
                      labelText: "profile.location",
                      onTap: viewModel.onLocationUpdate,
                    ),
                    PositiveVisibilityHint(toggleState: viewModelState.toggleStateLocation),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Your Interests -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  listSpacingSize: kPaddingSmall,
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_interests,
                      //TODO replace with bio
                      labelText: "profile.yourInterests",
                      onTap: viewModel.onYouInterestsUpdate,
                    ),
                    PositiveVisibilityHint(toggleState: viewModelState.toggleStateYouInterests),
                  ],
                ),
                // ProfileSettingsContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
