// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../../components/atoms/typography/bulleted_text.dart';
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingOurPledgeComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingOurPledgeComponent({
    super.key,
    required this.step,
    required this.index,
    required this.pageCount,
    required this.onCheckboxSelected,
    required this.onContinueSelected,
    required this.hasAccepted,
    required this.onBackSelected,
    required this.displayBackButton,
  });

  final OnboardingStep step;
  final int index;
  final int pageCount;

  final Future<void> Function() onBackSelected;
  final Future<void> Function() onContinueSelected;
  final Future<void> Function() onCheckboxSelected;

  final bool hasAccepted;
  final bool displayBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    return PPOScaffold(
      backgroundColor: branding.colors.colorWhite,
      children: <Widget>[
        _OnboardingOurPledgeContent(
          mediaQueryData: mediaQueryData,
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          pageIndex: index,
          totalPageCount: pageCount,
          onBackSelected: onBackSelected,
          onCheckboxSelected: onCheckboxSelected,
          hasAccepted: hasAccepted,
          displayBackButton: displayBackButton,
        ),
        _OnboardingOurPledgeFooter(
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          onContinueSelected: onContinueSelected,
          hasAccepted: hasAccepted,
        ),
      ],
    );
  }
}

class _OnboardingOurPledgeContent extends StatelessWidget {
  const _OnboardingOurPledgeContent({
    Key? key,
    required this.mediaQueryData,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.pageIndex,
    required this.totalPageCount,
    required this.onCheckboxSelected,
    required this.hasAccepted,
    required this.onBackSelected,
    required this.displayBackButton,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;
  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final int pageIndex;
  final int totalPageCount;

  final Future<void> Function() onBackSelected;
  final Future<void> Function() onCheckboxSelected;

  final bool displayBackButton;
  final bool hasAccepted;

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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (displayBackButton) ...<Widget>[
                  PPOButton(
                    brand: branding,
                    isDisabled: isBusy,
                    onTapped: onBackSelected,
                    label: localizations.shared_actions_back,
                    style: PPOButtonStyle.text,
                    layout: PPOButtonLayout.textOnly,
                  ),
                  kPaddingMedium.asHorizontalWidget,
                ],
                PPOPageIndicator(
                  branding: branding,
                  pagesNum: totalPageCount,
                  currentPage: pageIndex.toDouble(),
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.onboarding_pledge_our_title,
              style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.onboarding_pledge_our_heading,
              style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_our_b1,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_our_b2,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_our_b3,
                style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PPOCheckbox(
              brand: branding,
              onTapped: onCheckboxSelected,
              label: localizations.onboarding_pledge_our_cb_label,
              isChecked: hasAccepted,
              isDisabled: isBusy,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingOurPledgeFooter extends StatelessWidget {
  const _OnboardingOurPledgeFooter({
    Key? key,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.onContinueSelected,
    required this.hasAccepted,
  }) : super(key: key);

  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final Future<void> Function() onContinueSelected;
  final bool hasAccepted;

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
