// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/actions/system/system_busy_toggle_action.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/actions/user/google_sign_in_request_action.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../../business/actions/user/firebase_create_account_action.dart';
import '../components/atoms/buttons/enumerations/ppo_button_layout.dart';
import '../components/atoms/buttons/enumerations/ppo_button_style.dart';
import '../components/atoms/buttons/ppo_button.dart';
import '../components/molecules/navigation/ppo_app_bar.dart';
import '../constants/ppo_design_constants.dart';

class CreateAccountPage extends HookConsumerWidget with ServiceMixin {
  const CreateAccountPage({super.key});

  Future<void> onSignInWithGoogleRequested() async {
    try {
      await mutator.performAction<SystemBusyToggleAction>(params: [true]);
      await mutator.performAction<GoogleSignInRequestAction>();
      await mutator.performAction<FirebaseCreateAccountAction>();
    } finally {
      await mutator.performAction<SystemBusyToggleAction>(params: [false]);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PPOScaffold(
      trailingWidgets: <Widget>[
        PPOButton(
          brand: branding,
          isDisabled: isBusy,
          onTapped: onSignInWithGoogleRequested,
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
          activeColor: branding.colors.pink,
          iconWidget: SvgPicture.asset(
            SvgImages.logosCircular,
            color: branding.colors.black,
            height: PPOButton.kButtonIconRadiusRegular,
          ),
        ),
      ],
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PPOButton(
                        brand: branding,
                        isDisabled: isBusy,
                        onTapped: () async => router.push(OnboardingRoute(stepIndex: 0, displayPledgeOnly: false)),
                        label: localizations.shared_actions_back,
                        style: PPOButtonStyle.text,
                        layout: PPOButtonLayout.textOnly,
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
      ],
    );
  }
}
