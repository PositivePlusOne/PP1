// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../constants/ppo_design_constants.dart';
import 'splash_keys.dart';
import 'splash_lifecycle.dart';

class SplashPage extends HookConsumerWidget with ServiceMixin, LifecycleMixin {
  const SplashPage({
    this.style = SplashStyle.embracePositivity,
    super.key,
  });

  final SplashStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useLifecycleHook(SplashLifecycle());

    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final double boxHeight = screenSize.height / 2;
    late Widget child;

    switch (style) {
      default:
        child = const _SplashEmbracePositivityComponent();
    }

    return PPOScaffold(
      backgroundColor: brand.colors.white,
      children: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: boxHeight,
            width: double.infinity,
            child: child,
          ),
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
              child: SvgPicture.asset(
                SvgImages.footerLogo,
                color: brand.colors.black,
                width: kLogoMaximumWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashEmbracePositivityComponent extends HookConsumerWidget with ServiceMixin {
  const _SplashEmbracePositivityComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Container(
      color: Colors.red,
    );
  }
}
