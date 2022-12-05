import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/actions/user/google_sign_in_request_action.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import 'package:unicons/unicons.dart';

import '../components/atoms/buttons/enumerations/ppo_button_layout.dart';
import '../components/atoms/buttons/enumerations/ppo_button_style.dart';
import '../components/atoms/buttons/ppo_button.dart';
import '../components/atoms/containers/ppo_glass_container.dart';
import '../components/molecules/navigation/ppo_app_bar.dart';
import '../constants/ppo_design_constants.dart';
import '../constants/ppo_design_keys.dart';

class CreateAccountPage extends HookConsumerWidget with ServiceMixin {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PPOScaffold(
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                PPOAppBar(foregroundColor: branding.colors.black),
                const SizedBox(height: kPaddingSection),
                Row(
                  children: <Widget>[
                    Hero(
                      tag: kTagOnboardingBackButton,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PPOButton(
                          brand: branding,
                          isDisabled: isBusy,
                          onTapped: () async => router.removeLast(),
                          label: localizations.shared_actions_back,
                          style: PPOButtonStyle.text,
                          layout: PPOButtonLayout.textOnly,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.register_create_account_title,
                    style: branding.typography.styleHero.copyWith(
                      color: branding.colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.register_create_account_body,
                    style: branding.typography.styleBody.copyWith(
                      color: branding.colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(kPaddingSmall),
                child: PPOGlassContainer(
                  sigmaBlur: 0.0,
                  brand: branding,
                  children: <Widget>[
                    PPOButton(
                      brand: branding,
                      isDisabled: isBusy,
                      onTapped: () async => mutator.performAction<GoogleSignInRequestAction>(),
                      label: localizations.register_create_account_continue_with_google,
                      icon: UniconsLine.google,
                      layout: PPOButtonLayout.iconLeft,
                      style: PPOButtonStyle.secondary,
                    ),
                    const SizedBox(height: kPaddingMedium),
                    PPOButton(
                      brand: branding,
                      isDisabled: isBusy,
                      onTapped: () async {},
                      label: localizations.register_create_account_continue_with_apple,
                      icon: UniconsLine.apple,
                      layout: PPOButtonLayout.iconLeft,
                      style: PPOButtonStyle.secondary,
                    ),
                    const SizedBox(height: kPaddingMedium),
                    PPOButton(
                      brand: branding,
                      isDisabled: isBusy,
                      onTapped: () async {},
                      label: localizations.register_create_account_continue_with_facebook,
                      icon: UniconsLine.facebook_f,
                      layout: PPOButtonLayout.iconLeft,
                      style: PPOButtonStyle.secondary,
                    ),
                    const SizedBox(height: kPaddingExtraLarge),
                    PPOButton(
                      brand: branding,
                      isDisabled: isBusy,
                      onTapped: () async {},
                      label: localizations.register_create_account_login,
                      layout: PPOButtonLayout.iconLeft,
                      style: PPOButtonStyle.primary,
                      primaryColor: branding.colors.pink,
                      iconWidget: SvgPicture.asset(
                        SvgImages.logosCircular,
                        color: branding.colors.black,
                        height: PPOButton.kButtonIconRadiusRegular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
