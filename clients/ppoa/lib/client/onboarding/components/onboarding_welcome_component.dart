// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/client/extensions/math_extensions.dart';
import 'package:ppoa/resources/resources.dart';
import '../../components/atoms/stamps/stamp.dart';
import '../../components/molecules/navigation/ppo_app_bar.dart';
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';

class OnboardingWelcomeComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingWelcomeComponent({
    super.key,
    required this.step,
    required this.backgroundColor,
    required this.index,
    required this.pageCount,
    required this.onContinueSelected,
    required this.onSkipSelected,
    required this.onSignInSelected,
  });

  final OnboardingStep step;
  final Color backgroundColor;
  final int index;
  final int pageCount;

  final Future<void> Function() onSignInSelected;
  final Future<void> Function() onContinueSelected;
  final Future<void> Function() onSkipSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    return PPOScaffold(
      backgroundColor: backgroundColor,
      children: <Widget>[
        _OnboardingWelcomeContent(
          mediaQueryData: mediaQueryData,
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          pageIndex: index,
          totalPageCount: pageCount,
          onSkipSelected: onSkipSelected,
          backgroundColor: backgroundColor,
        ),
        _OnboardingWelcomeFooter(
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          onSignInSelected: onSignInSelected,
          onContinueSelected: onContinueSelected,
        ),
      ],
    );
  }
}

class _OnboardingWelcomeContent extends StatelessWidget {
  const _OnboardingWelcomeContent({
    Key? key,
    required this.mediaQueryData,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.pageIndex,
    required this.totalPageCount,
    required this.onSkipSelected,
    required this.backgroundColor,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;
  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final int pageIndex;
  final int totalPageCount;

  final Future<void> Function() onSkipSelected;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: kPaddingMedium + mediaQueryData.padding.top,
        left: kPaddingMedium,
        right: kPaddingMedium,
        bottom: kPaddingMedium,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            PPOAppBar(
              foregroundColor: branding.colors.black,
            ),
            const SizedBox(height: kPaddingSection),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PPOPageIndicator(
                  branding: branding,
                  pagesNum: totalPageCount,
                  currentPage: pageIndex.toDouble(),
                ),
                PPOButton(
                  brand: branding,
                  isDisabled: isBusy,
                  onTapped: onSkipSelected,
                  label: localizations.shared_actions_skip,
                  style: PPOButtonStyle.text,
                  layout: PPOButtonLayout.textOnly,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      localizations.onboarding_welcome_heading_p1,
                      style: branding.typography.styleHero.copyWith(color: branding.colors.black),
                    ),
                    Text(
                      localizations.onboarding_welcome_heading_p2,
                      style: branding.typography.styleHero.copyWith(color: branding.colors.black),
                    ),
                    Text(
                      localizations.onboarding_welcome_heading_p3,
                      style: branding.typography.styleHero.copyWith(color: branding.colors.black),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: kPaddingMedium, right: kPaddingMedium),
                    child: Transform.rotate(
                      angle: 15.0.degreeToRadian,
                      child: Stamp.smile(
                        alignment: Alignment.topRight,
                        branding: branding,
                        fillColour: branding.colors.pink,
                        size: 96.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              localizations.onboarding_welcome_heading_p4,
              style: branding.typography.styleHero.copyWith(color: branding.colors.black),
            ),
            kPaddingMedium.asVerticalWidget,
            Text(
              localizations.onboarding_welcome_body,
              style: branding.typography.styleBody.copyWith(color: branding.colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingWelcomeFooter extends StatelessWidget {
  const _OnboardingWelcomeFooter({
    Key? key,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.onSignInSelected,
    required this.onContinueSelected,
  }) : super(key: key);

  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final Future<void> Function() onSignInSelected;
  final Future<void> Function() onContinueSelected;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: PPOButton(
                        brand: branding,
                        isDisabled: isBusy,
                        onTapped: onSignInSelected,
                        label: localizations.shared_actions_sign_in,
                        layout: PPOButtonLayout.textOnly,
                        style: PPOButtonStyle.tertiary,
                      ),
                    ),
                    kPaddingMedium.asHorizontalWidget,
                    Expanded(
                      child: PPOButton(
                        brand: branding,
                        isDisabled: isBusy,
                        onTapped: onContinueSelected,
                        label: localizations.shared_actions_continue,
                        layout: PPOButtonLayout.textOnly,
                        style: PPOButtonStyle.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
