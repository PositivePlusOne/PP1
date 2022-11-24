import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import '../../constants/ppo_design_constants.dart';
import '../../constants/ppo_design_keys.dart';

class OnboardingWelcomeComponent extends HookConsumerWidget with ServiceMixin {
  const OnboardingWelcomeComponent({
    super.key,
    required this.step,
    required this.backgroundColor,
    required this.index,
    required this.pageCount,
  });

  final OnboardingStep step;
  final Color backgroundColor;
  final int index;
  final int pageCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PPOScaffold(
      backgroundColor: backgroundColor,
      children: <Widget>[
        SliverPadding(
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
                    PPOPageIndicator(branding: branding, pagesNum: 5, currentPage: 0),
                    PPOButton(
                      brand: branding,
                      onTapped: () async {},
                      label: 'Skip',
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
                          'Think,',
                          style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
                        ),
                        Text(
                          'Feel,',
                          style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
                        ),
                        Text(
                          'Live,',
                          style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
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
                  'Positively',
                  style: branding.typography.styleHero.copyWith(color: branding.colors.colorBlack),
                ),
                kPaddingMedium.asVerticalWidget,
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque placerat facilisis dolor id sollicitudin.',
                  style: branding.typography.styleBody.copyWith(color: branding.colors.colorBlack),
                ),
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
                  brand: branding,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: PPOButton(
                            brand: branding,
                            onTapped: () async {},
                            label: 'Sign In / Register',
                            layout: PPOButtonLayout.textOnly,
                            style: PPOButtonStyle.tertiary,
                          ),
                        ),
                        kPaddingMedium.asHorizontalWidget,
                        Expanded(
                          child: PPOButton(
                            brand: branding,
                            onTapped: () async {},
                            label: 'Continue',
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
        ),
      ],
    );
  }
}
