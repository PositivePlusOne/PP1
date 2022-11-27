// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../../components/atoms/buttons/ppo_checkbox.dart';
import '../../components/atoms/typography/bulleted_text.dart';
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingYourPledgeComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingYourPledgeComponent({
    super.key,
    required this.step,
    required this.index,
    required this.pageCount,
    required this.onContinueSelected,
    required this.onCheckboxSelected,
    required this.hasAccepted,
  });

  final OnboardingStep step;
  final int index;
  final int pageCount;

  final Future<void> Function() onContinueSelected;
  final Future<void> Function() onCheckboxSelected;
  final bool hasAccepted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    return PPOScaffold(
      backgroundColor: branding.colors.colorWhite,
      children: <Widget>[
        _OnboardingYourPledgeContent(
          mediaQueryData: mediaQueryData,
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          pageIndex: index,
          totalPageCount: pageCount,
          hasAccepted: hasAccepted,
          onCheckboxSelected: onCheckboxSelected,
        ),
        _OnboardingYourPledgeFooter(
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          hasAccepted: hasAccepted,
          onContinueSelected: onContinueSelected,
        ),
      ],
    );
  }
}

class _OnboardingYourPledgeContent extends StatelessWidget {
  const _OnboardingYourPledgeContent({
    Key? key,
    required this.mediaQueryData,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.pageIndex,
    required this.totalPageCount,
    required this.hasAccepted,
    required this.onCheckboxSelected,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;
  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final int pageIndex;
  final int totalPageCount;

  final bool hasAccepted;
  final Future<void> Function() onCheckboxSelected;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: kPaddingMedium + mediaQueryData.padding.top,
        left: kPaddingMedium,
        right: kPaddingMedium,
        bottom: kPaddingMedium + mediaQueryData.padding.bottom,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            Hero(
              tag: kTagAppBarLogo,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  SvgImages.footerLogo,
                  width: kLogoMaximumWidth,
                ),
              ),
            ),
            const SizedBox(height: kPaddingSection),
            PPOPageIndicator(
              branding: branding,
              pagesNum: totalPageCount,
              currentPage: pageIndex.toDouble(),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.onboarding_pledge_your_title,
              style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.onboarding_pledge_your_heading,
              style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b1,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b2,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b3,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b4,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b5,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PPOCheckbox(
              brand: branding,
              onTapped: onCheckboxSelected,
              label: localizations.onboarding_pledge_your_cb_label,
              isChecked: hasAccepted,
              isDisabled: isBusy,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingYourPledgeFooter extends StatelessWidget {
  const _OnboardingYourPledgeFooter({
    Key? key,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.hasAccepted,
    required this.onContinueSelected,
  }) : super(key: key);

  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;
  final bool hasAccepted;

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
                PPOButton(
                  brand: branding,
                  isDisabled: isBusy || !hasAccepted,
                  onTapped: onContinueSelected,
                  label: localizations.shared_actions_continue,
                  layout: PPOButtonLayout.textOnly,
                  style: PPOButtonStyle.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
