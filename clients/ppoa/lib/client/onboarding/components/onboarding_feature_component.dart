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
import 'package:ppoa/resources/resources.dart';
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingFeatureComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingFeatureComponent({
    super.key,
    required this.step,
    required this.backgroundColor,
    required this.index,
    required this.pageCount,
    required this.markdown,
  });

  final OnboardingStep step;
  final Color backgroundColor;
  final int index;
  final int pageCount;
  final String markdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));

    return PPOScaffold(
      backgroundColor: backgroundColor,
      children: <Widget>[
        _OnboardingFeatureContent(
          backgroundColor: backgroundColor,
          mediaQueryData: mediaQueryData,
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          pageIndex: index,
          totalPageCount: pageCount,
          markdown: markdown,
        ),
        _OnboardingFeatureFooter(
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
        ),
      ],
    );
  }
}

class _OnboardingFeatureContent extends StatelessWidget {
  const _OnboardingFeatureContent({
    Key? key,
    required this.backgroundColor,
    required this.mediaQueryData,
    required this.branding,
    required this.isBusy,
    required this.localizations,
    required this.pageIndex,
    required this.totalPageCount,
    required this.markdown,
  }) : super(key: key);

  final Color backgroundColor;
  final MediaQueryData mediaQueryData;
  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final int pageIndex;
  final int totalPageCount;

  final String markdown;

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
                  onTapped: () async {},
                  label: localizations.shared_actions_skip,
                  style: PPOButtonStyle.text,
                  layout: PPOButtonLayout.textOnly,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Markdown(
              data: markdown,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              styleSheet: branding.getMarkdownStyleSheet(backgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingFeatureFooter extends StatelessWidget {
  const _OnboardingFeatureFooter({
    Key? key,
    required this.branding,
    required this.isBusy,
    required this.localizations,
  }) : super(key: key);

  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

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
                  isDisabled: isBusy,
                  onTapped: () async {},
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
