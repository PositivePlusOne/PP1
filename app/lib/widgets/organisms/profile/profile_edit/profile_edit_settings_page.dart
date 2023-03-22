// Flutter imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/organisms/profile/profile_edit/vms/profile_edit_settings_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../atoms/indicators/positive_profile_image_indicator.dart';
import '../../../molecules/containers/positive_transparent_sheet.dart';
import '../../../molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_fake_text_field_button.dart';
import 'package:app/widgets/organisms/profile/profile_edit/profile_edit_settings_content.dart';

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
                    const CheckboxWithText(toggleState: ToggleState.alwaysActive),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                //* -=-=-=-=-=- Date of Birth -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                PositiveTransparentSheet(
                  children: <Widget>[
                    PositiveFakeTextFieldButton(
                      hintText: localizations.page_profile_edit_dob,
                      //TODO replace with Date of Birth
                      labelText: "profile.dateOfBirth",
                      //? empty onTap, users may not update date of birth in app
                      onTap: () {},
                    ),
                    RichText(
                      text: TextSpan(
                        text: localizations.page_profile_edit_change_details,
                        style: typography.styleSubtitle.copyWith(color: colors.colorGray1.complimentTextColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: localizations.page_profile_edit_change_details_link,
                            style: typography.styleSubtitle.copyWith(color: colors.linkBlue),
                          )
                        ],
                      ),
                    ),
                    CheckboxWithText(toggleState: viewModelState.toggleStateDateOfBirth),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Gender -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_gender,
                      //TODO replace with gender
                      labelText: "profile.gender",
                      onTap: viewModel.onGenderUpdate,
                    ),
                    CheckboxWithText(toggleState: viewModelState.toggleStateGender),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- HIV Status -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_hiv_status,
                      //TODO replace with hiv status
                      labelText: "profile.HIVStatus",
                      onTap: viewModel.onHIVStatusUpdate,
                    ),
                    CheckboxWithText(toggleState: viewModelState.toggleStateHIVStatus),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Location -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_location,
                      //TODO replace with location
                      labelText: "profile.location",
                      onTap: viewModel.onLocationUpdate,
                    ),
                    CheckboxWithText(toggleState: viewModelState.toggleStateLocation),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Your Interests -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveTransparentSheet(
                  children: <Widget>[
                    PositiveFakeTextFieldButton.profile(
                      hintText: localizations.page_profile_edit_interests,
                      //TODO replace with bio
                      labelText: "profile.yourInterests",
                      onTap: viewModel.onYouInterestsUpdate,
                    ),
                    CheckboxWithText(toggleState: viewModelState.toggleStateYouInterests),
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
