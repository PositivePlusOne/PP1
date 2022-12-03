// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

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
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:ppoa/resources/resources.dart';
import '../../components/atoms/buttons/ppo_checkbox.dart';
import '../../components/atoms/typography/bulleted_text.dart';
import '../../components/molecules/navigation/ppo_app_bar.dart';
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingYourPledgeComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingYourPledgeComponent({
    super.key,
    required this.step,
    required this.index,
    required this.pageCount,
    required this.onBackSelected,
    required this.onContinueSelected,
    required this.onCheckboxSelected,
    required this.hasAccepted,
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
      backgroundColor: branding.colors.white,
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
          onBackSelected: onBackSelected,
          displayBackButton: displayBackButton,
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

class _OnboardingYourPledgeContent extends StatelessWidget with ServiceMixin {
  const _OnboardingYourPledgeContent({
    Key? key,
    required this.mediaQueryData,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.pageIndex,
    required this.totalPageCount,
    required this.onBackSelected,
    required this.onCheckboxSelected,
    required this.hasAccepted,
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

  final bool hasAccepted;
  final bool displayBackButton;

  @override
  Widget build(BuildContext context) {
    final MarkdownStyleSheet markdownStyle = branding.getMarkdownStyleSheet(branding.colors.white);

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
            PPOAppBar(
              foregroundColor: branding.colors.black,
            ),
            const SizedBox(height: kPaddingSection),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (displayBackButton) ...<Widget>[
                  Hero(
                    tag: kTagOnboardingBackButton,
                    child: PPOButton(
                      brand: branding,
                      isDisabled: isBusy,
                      onTapped: onBackSelected,
                      label: localizations.shared_actions_back,
                      style: PPOButtonStyle.text,
                      layout: PPOButtonLayout.textOnly,
                    ),
                  ),
                  kPaddingMedium.asHorizontalWidget,
                ],
                PPOPageIndicator(
                  branding: branding,
                  pagesNum: totalPageCount,
                  currentPage: pageIndex.toDouble(),
                ),
                //! Hack to make sure the height is the same across Onboarding views
                Opacity(
                  opacity: 0.0,
                  child: PPOButton(
                    brand: branding,
                    isDisabled: true,
                    onTapped: () async {},
                    label: '0',
                    style: PPOButtonStyle.text,
                    layout: PPOButtonLayout.textOnly,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  localizations.onboarding_pledge_your_title,
                  style: branding.typography.styleHero.copyWith(
                    color: branding.colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.onboarding_pledge_your_heading,
              style: branding.typography.styleBody.copyWith(color: branding.colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b1,
                style: branding.typography.styleBody.copyWith(color: branding.colors.black),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b2,
                style: branding.typography.styleBody.copyWith(color: branding.colors.black),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b3,
                style: branding.typography.styleBody.copyWith(color: branding.colors.black),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b4,
                style: branding.typography.styleBody.copyWith(color: branding.colors.black),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            BulletedText(
              text: Text(
                localizations.onboarding_pledge_your_b5,
                style: branding.typography.styleBody.copyWith(color: branding.colors.black),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Markdown(
              data: localizations.onboarding_pledge_your_tcs_md,
              padding: EdgeInsets.zero,
              styleSheet: markdownStyle,
              shrinkWrap: true,
              onTapLink: (_, __, ___) => router.push(const TermsAndConditionsDialog()),
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
