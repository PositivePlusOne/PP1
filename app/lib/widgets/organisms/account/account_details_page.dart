// Flutter imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/dtos/localization/country.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_dropdown.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_details_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_fake_text_field_button.dart';
import '../../molecules/containers/positive_transparent_sheet.dart';

@RoutePage()
class AccountDetailsPage extends HookConsumerWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter router = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final AccountDetailsViewModel viewModel = ref.read(accountDetailsViewModelProvider.notifier);
    final AccountDetailsViewModelState viewModelState = ref.watch(accountDetailsViewModelProvider);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    useLifecycleHook(viewModel);

    final Profile? profile = profileState.currentProfile;
    final String name = profile?.name ?? '';
    final String emailAddress = profile?.email ?? '';
    final String phoneNumber = profile?.phoneNumber ?? '';

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final List<Widget> actions = [];
    if (profileState.currentProfile != null) {
      actions.addAll(profileState.currentProfile!.buildCommonProfilePageActions(disableAccount: true));
    }

    final (String countryCode, String formattedPhoneNumber) phoneNumberComponents = phoneNumber.formatPhoneNumberIntoComponents();

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          appBarLeading: PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: () => router.removeLast(),
          ),
          appBarTrailing: actions,
          children: <Widget>[
            Text(
              localisations.page_account_actions_details,
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: localisations.shared_name,
              labelText: name,
              onTap: (_) {},
              isEnabled: !viewModelState.isBusy,
              suffixIcon: PositiveTextFieldIcon.action(backgroundColor: colors.purple),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: localisations.shared_email_address,
              labelText: emailAddress,
              onTap: viewModel.onUpdateEmailAddressButtonPressed,
              isEnabled: !viewModelState.isBusy,
              suffixIcon: PositiveTextFieldIcon.action(backgroundColor: colors.purple),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: localisations.shared_phone_number,
              labelText: phoneNumberComponents.$2,
              onTap: viewModel.onUpdatePhoneNumberButtonPressed,
              isEnabled: !viewModelState.isBusy,
              suffixIcon: PositiveTextFieldIcon.action(backgroundColor: colors.purple),
              prefixIcon: phoneNumberComponents.$1.isEmpty
                  ? null
                  : PositiveTextFieldPrefixContainer(
                      color: colors.colorGray6,
                      isPreviewOnly: true,
                      child: PositiveTextFieldPrefixDropdown<Country>(
                        onValueChanged: (_) {},
                        isPreviewOnly: true,
                        initialValue: kCountryList.firstWhere((element) => element.phoneCode == '44'),
                        valueStringBuilder: (value) => '${value.name} (+${value.phoneCode})',
                        placeholderStringBuilder: (value) => '+${value.phoneCode}',
                        values: kCountryList,
                      ),
                    ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: viewModel.onUpdatePasswordButtonPressed,
              isDisabled: viewModelState.isBusy,
              primaryColor: colors.white,
              label: localisations.page_account_actions_change_password,
              icon: UniconsLine.lock_alt,
              style: PositiveButtonStyle.primary,
            ),
            const SizedBox(height: kPaddingMedium),
            if (viewModelState.googleUserInfo != null) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectGoogleProviderPressed,
                isDisabled: viewModelState.isBusy,
                primaryColor: colors.white,
                label: localisations.page_account_actions_change_disable_google_sign_in,
                icon: UniconsLine.google,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            if (viewModelState.appleUserInfo != null) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectAppleProviderPressed,
                isDisabled: viewModelState.isBusy,
                primaryColor: colors.white,
                label: localisations.page_account_actions_change_disable_apple_sign_in,
                icon: UniconsLine.apple,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            if (viewModelState.facebookUserInfo != null) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectFacebookProviderPressed,
                isDisabled: viewModelState.isBusy,
                primaryColor: colors.white,
                label: localisations.page_account_actions_change_disable_facebook_sign_in,
                icon: UniconsLine.facebook_f,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            if (viewModelState.googleUserInfo == null || viewModelState.facebookUserInfo == null || viewModelState.googleUserInfo == null || viewModelState.appleUserInfo != null) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onConnectSocialUserRequested,
                isDisabled: viewModelState.isBusy,
                primaryColor: colors.white,
                label: localisations.page_account_actions_change_connect_social_account,
                icon: UniconsLine.link_alt,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            PositiveButton(
              colors: colors,
              onTapped: viewModel.onDeleteAccountButtonPressed,
              isDisabled: viewModelState.isBusy,
              primaryColor: colors.black,
              label: localisations.page_account_actions_change_delete_account,
              style: PositiveButtonStyle.text,
            ),
          ],
        ),
      ],
    );
  }
}
