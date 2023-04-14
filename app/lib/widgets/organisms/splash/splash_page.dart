// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/splash/embrace_positivity_placeholder.dart';
import 'package:app/widgets/molecules/splash/lets_keep_it_real_placeholder.dart';
import 'package:app/widgets/molecules/splash/tomorrow_starts_now_placeholder.dart';
import 'package:app/widgets/molecules/splash/we_are_done_hiding_placeholder.dart';
import 'package:app/widgets/molecules/splash/your_condition_your_terms_placeholder.dart';
import 'package:app/widgets/organisms/splash/vms/splash_view_model.dart';

enum SplashStyle {
  embracePositivity,
  weAreDoneHiding,
  yourConditionYourTerms,
  letsKeepItReal,
  tomorrowStartsNow,
}

@RoutePage()
class SplashPage extends HookConsumerWidget with LifecycleMixin {
  const SplashPage({
    super.key,
    this.style = SplashStyle.embracePositivity,
  });

  final SplashStyle style;

  Color getBackgroundColor(DesignColorsModel colors) {
    switch (style) {
      case SplashStyle.embracePositivity:
        return colors.white;
      case SplashStyle.weAreDoneHiding:
        return colors.pink;
      case SplashStyle.yourConditionYourTerms:
        return colors.yellow;
      case SplashStyle.letsKeepItReal:
        return colors.green;
      case SplashStyle.tomorrowStartsNow:
        return colors.purple;
    }
  }

  Widget getChildWidget() {
    switch (style) {
      case SplashStyle.embracePositivity:
        return const EmbracePositivityPlaceholder();
      case SplashStyle.weAreDoneHiding:
        return const WeAreDoneHidingPlaceholder();
      case SplashStyle.yourConditionYourTerms:
        return const YourConditionYourTermsPlaceholder();
      case SplashStyle.letsKeepItReal:
        return const LetsKeepItRealPlaceholder();
      case SplashStyle.tomorrowStartsNow:
        return const TomorrowStartsNowPlaceholder();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final Widget child = getChildWidget();
    final Color backgroundColor = getBackgroundColor(colors);

    //* Listen for initial page pushes
    //* This is auto disposed by Riverpod.
    final SplashViewModelProvider splashProvider = splashViewModelProvider(style);
    final SplashViewModel notifier = ref.read(splashProvider.notifier);
    useLifecycleHook(notifier);

    return PositiveScaffold(
      backgroundColor: backgroundColor,
      onWillPopScope: () async => false,
      headingWidgets: <Widget>[
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
                    bottom: kPaddingExtraLarge + mediaQuery.padding.bottom,
                  ),
                  child: SvgPicture.asset(
                    SvgImages.logosFooter,
                    color: colors.black,
                    width: kLogoMaximumWidth,
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
