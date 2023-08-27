// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/localization/country.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_details_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_fake_text_field_button.dart';

@RoutePage()
class AccountDetailsPage extends HookConsumerWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter router = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Locale locale = Localizations.localeOf(context);

    final AccountDetailsViewModel viewModel = ref.read(accountDetailsViewModelProvider.notifier);
    final AccountDetailsViewModelState viewModelState = ref.watch(accountDetailsViewModelProvider);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);

    useLifecycleHook(viewModel);

    final Profile? profile = profileState.currentProfile;
    final String name = profile?.name ?? '';
    final String emailAddress = profile?.email ?? '';
    final String phoneNumber = profile?.phoneNumber ?? '';

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
              onTap: (context) => viewModel.onUpdateEmailAddressButtonPressed(context, locale, controller),
              isEnabled: !viewModelState.isBusy,
              suffixIcon: PositiveTextFieldIcon.action(backgroundColor: colors.purple),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: localisations.shared_phone_number,
              labelText: phoneNumberComponents.$2,
              onTap: (context) => viewModel.onUpdatePhoneNumberButtonPressed(context, locale, controller),
              isEnabled: !viewModelState.isBusy,
              suffixIcon: PositiveTextFieldIcon.action(backgroundColor: colors.purple),
              prefixIcon: phoneNumberComponents.$1.isEmpty
                  ? null
                  : PositiveTextFieldPrefixContainer(
                      color: colors.colorGray6,
                      isPreviewOnly: true,
                      //! THIS SHOULD BE THE USERS COUNTRY
                      child: PositiveTextFieldPrefixDropdown<Country>(
                        onValueChanged: (_) {},
                        isPreviewOnly: true,
                        initialValue: Country.fromPhoneCode(phoneNumberComponents.$1) ?? Country.fromContext(context),
                        valueStringBuilder: (value) => '${value.name} (+${value.phoneCode})',
                        placeholderStringBuilder: (value) => '+${value.phoneCode}',
                        values: kCountryListSortedWithTargetsFirst,
                      ),
                    ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: () => viewModel.onUpdatePasswordButtonPressed(context, locale, controller),
              isDisabled: viewModelState.isBusy,
              primaryColor: colors.white,
              label: localisations.page_account_actions_change_password,
              icon: UniconsLine.lock_alt,
              fontColorOverride: colors.colorGray7,
              iconColorOverride: colors.colorGray7,
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
                fontColorOverride: colors.colorGray7,
                iconColorOverride: colors.colorGray7,
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
                fontColorOverride: colors.colorGray7,
                iconColorOverride: colors.colorGray7,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            //! TODO: Implement Facebook login
            // if (viewModelState.facebookUserInfo != null) ...<Widget>[
            //   PositiveButton(
            //     colors: colors,
            //     onTapped: viewModel.onDisconnectFacebookProviderPressed,
            //     isDisabled: viewModelState.isBusy,
            //     primaryColor: colors.white,
            //     label: localisations.page_account_actions_change_disable_facebook_sign_in,
            //     icon: UniconsLine.facebook_f,
            //     style: PositiveButtonStyle.primary,
            //   ),
            //   const SizedBox(height: kPaddingMedium),
            // ],
            if (viewModelState.googleUserInfo == null || viewModelState.facebookUserInfo == null || viewModelState.googleUserInfo == null || viewModelState.appleUserInfo != null) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onConnectSocialUserRequested,
                isDisabled: viewModelState.isBusy,
                primaryColor: colors.white,
                label: localisations.page_account_actions_change_connect_social_account,
                icon: UniconsLine.link_alt,
                fontColorOverride: colors.colorGray7,
                iconColorOverride: colors.colorGray7,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            PositiveButton(
              colors: colors,
              onTapped: () => viewModel.onDeleteAccountButtonPressed(context, locale, controller),
              isDisabled: viewModelState.isBusy,
              primaryColor: colors.colorGray7,
              label: localisations.page_account_actions_change_delete_account,
              style: PositiveButtonStyle.ghost,
            ),
          ],
        ),
      ],
    );
  }
}
