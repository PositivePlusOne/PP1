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
import 'package:ppoa/client/components/atoms/decorations/ppo_scaffold_decoration.dart';
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
    required this.onContinueSelected,
    required this.onSkipSelected,
  });

  final OnboardingStep step;
  final Color backgroundColor;
  final int index;
  final int pageCount;

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
      decorations: step.decorations.map((e) => PPOScaffoldDecoration.fromPageDecoration(e)).toList(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(kPaddingSmall),
        child: PPOGlassContainer(
          brand: branding,
          children: <Widget>[
            PPOButton(
              brand: branding,
              isDisabled: isBusy,
              onTapped: onContinueSelected,
              label: localizations.shared_actions_continue,
              layout: PPOButtonLayout.textOnly,
              style: PPOButtonStyle.secondary,
            ),
          ],
        ),
      ),
      children: <Widget>[
        _OnboardingFeatureContent(
          backgroundColor: backgroundColor,
          mediaQueryData: mediaQueryData,
          branding: branding,
          isBusy: isBusy,
          localizations: localizations,
          pageIndex: index,
          totalPageCount: pageCount,
          onSkipSelected: onSkipSelected,
          title: step.title,
          body: step.body,
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
    required this.onSkipSelected,
    required this.title,
    required this.body,
  }) : super(key: key);

  final Color backgroundColor;
  final MediaQueryData mediaQueryData;
  final DesignSystemBrand branding;
  final bool isBusy;
  final AppLocalizations localizations;

  final int pageIndex;
  final int totalPageCount;

  final Future<void> Function() onSkipSelected;

  final String title;
  final String body;

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
                  onTapped: onSkipSelected,
                  label: localizations.shared_actions_skip,
                  style: PPOButtonStyle.text,
                  layout: PPOButtonLayout.textOnly,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: branding.typography.styleHero.copyWith(
                    color: branding.colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              body,
              style: branding.typography.styleBody.copyWith(
                color: branding.colors.black,
              ),
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
      ),
    );
  }
}
