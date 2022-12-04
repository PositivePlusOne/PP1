// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/stamps/stamp.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/client/helpers/paint_helpers.dart';
import 'package:ppoa/resources/resources.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../constants/ppo_design_constants.dart';
import '../constants/ppo_design_keys.dart';
import 'splash_lifecycle.dart';

class SplashPage extends HookConsumerWidget with ServiceMixin, LifecycleMixin {
  const SplashPage({
    this.style = SplashStyle.embracePositivity,
    this.shouldPauseView = false,
    super.key,
  });

  final SplashStyle style;
  final bool shouldPauseView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SplashLifecycle lifecycle = SplashLifecycle()
      ..style = style
      ..shouldPauseView = shouldPauseView;

    useLifecycleHook(lifecycle);

    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    late Widget child;

    Color backgroundColor = branding.colors.white;

    switch (style) {
      case SplashStyle.weAreDoneHiding:
        child = const _SplashWeAreDoneHidingComponent();
        backgroundColor = branding.colors.pink;
        break;
      case SplashStyle.yourConditionYourTerms:
        child = const _SplashYourConditionYourTermsComponent();
        backgroundColor = branding.colors.yellow;
        break;
      case SplashStyle.letsKeepItReal:
        child = const _SplashLetsKeepItRealComponent();
        backgroundColor = branding.colors.green;
        break;
      case SplashStyle.tomorrowStartsNow:
        child = const _SplashTomorrowStartsNowComponent();
        backgroundColor = branding.colors.purple;
        break;
      case SplashStyle.embracePositivity:
      default:
        child = const _SplashEmbracePositivityComponent();
        backgroundColor = branding.colors.white;
        break;
    }

    return PPOScaffold(
      backgroundColor: backgroundColor,
      children: <Widget>[
        SliverStack(
          children: <Widget>[
            SliverFillRemaining(
              fillOverscroll: false,
              hasScrollBody: false,
              child: child,
            ),
            SliverFillRemaining(
              fillOverscroll: false,
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: kPaddingExtraLarge,
                    bottom: kPaddingExtraLarge + mediaQueryData.padding.bottom,
                  ),
                  child: Hero(
                    tag: kTagAppBarLogo,
                    child: SvgPicture.asset(
                      SvgImages.logosFooter,
                      color: branding.colors.black,
                      width: kLogoMaximumWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SplashEmbracePositivityComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashEmbracePositivityComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Size kTextSize = getTextSize(localizations.splash_ep_l2, branding.typography.styleHero);
    final double kBadgePaddingLeft = kTextSize.width * 0.75;

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.splash_ep_l1, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_ep_l2, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
            ],
          ),
        ),
        Positioned(
          left: kBadgePaddingLeft,
          top: 265.0,
          child: Stamp.onePlus(
            branding: branding,
            size: kBadgeSmallSize,
            text: '${localizations.shared_badges_positive}\n${localizations.shared_badges_positive}',
            animate: true,
            color: branding.colors.purple,
            textColor: branding.colors.purple,
          ),
        ),
      ],
    );
  }
}

class _SplashWeAreDoneHidingComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashWeAreDoneHidingComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = getTextSize(localizations.splash_wdh_l3, branding.typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 1.45;

    //* Layout sanity check
    if ((screenSize.width - kPaddingMedium) < (badgePaddingLeft + kBadgeSmallSize)) {
      badgePaddingLeft = screenSize.width - kPaddingMedium - kBadgeSmallSize;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.splash_wdh_l1, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_wdh_l2, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_wdh_l3, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 350.0,
          child: Stamp.smile(
            branding: branding,
            size: kBadgeSmallSize,
            fillColour: branding.colors.teal,
          ),
        ),
      ],
    );
  }
}

class _SplashYourConditionYourTermsComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashYourConditionYourTermsComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = getTextSize(localizations.splash_ycyt_l4, branding.typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 1.45;

    //* Layout sanity check
    if ((screenSize.width - kPaddingMedium) < (badgePaddingLeft + kBadgeSmallSize)) {
      badgePaddingLeft = screenSize.width - kPaddingMedium - kBadgeSmallSize;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.splash_ycyt_l1, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_ycyt_l2, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_ycyt_l3, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_ycyt_l4, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 380.0,
          child: Stamp.victory(
            branding: branding,
            size: kBadgeSmallSize,
            text: '${localizations.shared_badges_no_drama}\n${localizations.shared_badges_just_love}',
            color: branding.colors.black,
            textColor: branding.colors.black,
          ),
        ),
      ],
    );
  }
}

class _SplashLetsKeepItRealComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashLetsKeepItRealComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = getTextSize(localizations.splash_lkir_l3, branding.typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 1.10;

    //* Layout sanity check
    if ((screenSize.width - kPaddingMedium) < (badgePaddingLeft + kBadgeSmallSize)) {
      badgePaddingLeft = screenSize.width - kPaddingMedium - kBadgeSmallSize;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.splash_lkir_l1, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_lkir_l2, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_lkir_l3, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_lkir_l4, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 130.0,
          child: Stamp.fist(
            branding: branding,
            size: kBadgeSmallSize,
            text: '${localizations.shared_badges_im_a_lover}\n${localizations.shared_badges_and_a_fighter}',
            color: branding.colors.white,
            textColor: branding.colors.white,
          ),
        ),
      ],
    );
  }
}

class _SplashTomorrowStartsNowComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashTomorrowStartsNowComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = getTextSize(localizations.splash_tsn_l3, branding.typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 0.65;

    //* Layout sanity check
    if ((screenSize.width - kPaddingMedium) < (badgePaddingLeft + kBadgeSmallSize)) {
      badgePaddingLeft = screenSize.width - kPaddingMedium - kBadgeSmallSize;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.splash_tsn_l1, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_tsn_l2, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
              Text(localizations.splash_tsn_l3, style: branding.typography.styleHero.copyWith(color: branding.colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 345.0,
          child: Stamp.onePlus(
            branding: branding,
            size: kBadgeSmallSize,
            text: '${localizations.shared_badges_positive}\n${localizations.shared_badges_positive}',
            color: branding.colors.yellow,
            textColor: branding.colors.yellow,
            animate: true,
          ),
        ),
      ],
    );
  }
}
