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
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/localization/country.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_dropdown.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/components/account_profile_banner.dart';
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

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormController controller = ref.read(provider.notifier);

    final List<String> cacheKeys = [];

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

    final bool isPersonalAccount = profileController.isCurrentlyUserProfile;

    final String ownerId = profile?.flMeta?.ownedBy ?? '';
    if (ownerId.isNotEmpty) {
      cacheKeys.add(ownerId);
    }

    useCacheHook(keys: cacheKeys);

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Profile? ownerProfile = cacheController.get(ownerId);

    final bool isPendingDeletion = profile?.visibilityFlags.contains(kFeatureFlagPendingDeletion) == true;

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
            if (isPersonalAccount) ...<Widget>[
              ...buildPersonalAccountDetails(
                context: context,
                viewModel: viewModel,
                viewModelState: viewModelState,
                colors: colors,
                typography: typography,
                localisations: localisations,
                locale: locale,
                controller: controller,
                name: name,
                emailAddress: emailAddress,
                phoneNumberComponents: phoneNumberComponents,
                isPendingDeletion: isPendingDeletion,
              ),
            ] else ...<Widget>[
              ...buildManagedAccountDetails(
                context: context,
                viewModel: viewModel,
                viewModelState: viewModelState,
                colors: colors,
                typography: typography,
                localisations: localisations,
                locale: locale,
                controller: controller,
                profile: profile,
                ownerProfile: ownerProfile,
              ),
            ],
          ],
        ),
      ],
    );
  }

  List<Widget> buildManagedAccountDetails({
    required BuildContext context,
    required AccountDetailsViewModel viewModel,
    required AccountDetailsViewModelState viewModelState,
    required DesignColorsModel colors,
    required DesignTypographyModel typography,
    required AppLocalizations localisations,
    required Locale locale,
    required AccountFormController controller,
    required Profile? profile,
    required Profile? ownerProfile,
  }) {
    return [
      PositiveGlassSheet(
        horizontalPadding: kPaddingMedium,
        verticalPadding: kPaddingMedium,
        children: <Widget>[
          PositiveRichText(
            body: 'Need to change these details? Please get in touch with us at {} or call your representative.',
            onActionTapped: (_) => 'mailto:support@positiveplusone.com'.attemptToLaunchURL(),
            actions: const <String>['support@positiveplusone.com'],
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveVisibilityHint(
            toggleState: viewModelState.isBusy
                ? PositiveTogglableState.loading
                : profile?.hasDirectoryEntry == true
                    ? PositiveTogglableState.active
                    : PositiveTogglableState.inactive,
            isEnabled: false,
            style: PositiveVisibilityHintStyle.directoryStyle,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_account_details_managed_name,
            labelText: profile?.name ?? '',
            onTap: (_) {},
            isEnabled: false,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_account_details_managed_display_name,
            labelText: profile?.displayName.asHandle ?? '',
            onTap: (_) {},
            isEnabled: false,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_account_details_managed_sector,
            labelText: profile?.companySectors.join(', ') ?? '',
            onTap: (_) {},
            isEnabled: false,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_company_details_managed_address,
            labelText: profile?.formattedLocation ?? '',
            onTap: (_) {},
            isEnabled: false,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_company_details_managed_size,
            labelText: ProfileCompanySize.toLocale(profile?.companySize ?? const ProfileCompanySize.unknown()),
            onTap: (_) {},
            isEnabled: false,
          ),
          const SizedBox(height: kPaddingMedium),
          PositiveFakeTextFieldButton(
            hintText: localisations.page_company_details_managed_about,
            labelText: profile?.biography ?? '',
            onTap: (_) {},
            isEnabled: false,
          ),
          if (profile?.hasPromotionsEnabled == true) ...<Widget>[
            const SizedBox(height: kPaddingMedium),
            PositiveHint(
              label: localisations.page_company_details_managed_action_promoted,
              icon: UniconsLine.check_circle,
              iconColor: colors.black,
            ),
          ],
          if (ownerProfile != null) ...<Widget>[
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                child: Text(
                  localisations.page_company_details_managed_primary_user,
                  textAlign: TextAlign.start,
                  style: typography.styleSubtextBold.copyWith(color: colors.black),
                ),
              ),
            ),
            const SizedBox(height: kPaddingSmall),
            AccountProfileBanner(profile: ownerProfile),
          ],
        ],
      ),
    ];
  }

  List<Widget> buildPersonalAccountDetails({
    required BuildContext context,
    required AccountDetailsViewModel viewModel,
    required AccountDetailsViewModelState viewModelState,
    required DesignColorsModel colors,
    required DesignTypographyModel typography,
    required AppLocalizations localisations,
    required Locale locale,
    required AccountFormController controller,
    required String name,
    required String emailAddress,
    required (String, String) phoneNumberComponents,
    required bool isPendingDeletion,
  }) {
    return [
      Text(
        localisations.page_account_actions_details,
        style: typography.styleHeroMedium.copyWith(color: colors.black),
      ),
      const SizedBox(height: kPaddingMedium),
      PositiveFakeTextFieldButton(
        hintText: localisations.shared_name,
        labelText: name,
        onTap: (context) => viewModel.onUpdateNameButtonPressed(context, locale, controller),
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
        onTapped: () => isPendingDeletion ? viewModel.onUndeleteAccountButtonPressed(context, locale, controller) : viewModel.onDeleteAccountButtonPressed(context, locale, controller),
        isDisabled: viewModelState.isBusy,
        primaryColor: colors.colorGray7,
        label: isPendingDeletion ? localisations.page_account_actions_change_undelete_account : localisations.page_account_actions_change_delete_account,
        style: PositiveButtonStyle.ghost,
      ),
      if (isPendingDeletion) ...<Widget>[
        const SizedBox(height: kPaddingMedium),
        PositiveHint(
          label: localisations.page_account_actions_change_delete_account_pending,
          icon: UniconsLine.check_circle,
          iconColor: colors.black,
        ),
      ],
    ];
  }
}
