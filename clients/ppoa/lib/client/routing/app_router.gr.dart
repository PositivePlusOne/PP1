// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;

import '../components/atoms/buttons/ppo_button_test_page.dart' as _i6;
import '../components/atoms/buttons/ppo_checkbox_test_page.dart' as _i7;
import '../components/atoms/containers/ppo_glass_container_test_page.dart'
    as _i9;
import '../components/atoms/forms/ppo_text_field_test_page.dart' as _i8;
import '../components/atoms/page_indicator/ppo_page_indicator_test_page.dart'
    as _i12;
import '../components/atoms/pills/ppo_hint_test_page.dart' as _i13;
import '../components/atoms/reactive/ppo_pin_field_test_page.dart' as _i14;
import '../components/atoms/stamps/ppo_stamps_test_page.dart' as _i11;
import '../components/templates/scaffolds/ppo_scaffold_decoration_test_page.dart'
    as _i15;
import '../dialogs/terms_and_conditions_dialog.dart' as _i2;
import '../home/home_page.dart' as _i3;
import '../onboarding/onboarding_page.dart' as _i4;
import '../registration/create_account_page.dart' as _i5;
import '../simulation/views/ppo_typography_test_page.dart' as _i10;
import '../splash/splash_lifecycle.dart' as _i19;
import '../splash/splash_page.dart' as _i1;
import 'radial_transition_builder.dart' as _i18;

class AppRouter extends _i16.RootStackRouter {
  AppRouter([_i17.GlobalKey<_i17.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SplashPage(
          style: args.style,
          shouldPauseView: args.shouldPauseView,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    TermsAndConditionsDialog.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.TermsAndConditionsDialog(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    HomeRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>();
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.OnboardingPage(
          stepIndex: args.stepIndex,
          displayPledgeOnly: args.displayPledgeOnly,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.CreateAccountPage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOButtonTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestRouteArgs>(
          orElse: () => const PPOButtonTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.PPOButtonTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOCheckboxTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOCheckboxTestRouteArgs>(
          orElse: () => const PPOCheckboxTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i7.PPOCheckboxTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOTextFieldTestRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i8.PPOTextFieldTestPage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOGlassContainerTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestRouteArgs>(
          orElse: () => const PPOGlassContainerTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i9.PPOGlassContainerTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOTypographyTestRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i10.PPOTypographyTestPage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOStampTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOStampTestRouteArgs>(
          orElse: () => const PPOStampTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i11.PPOStampTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPORouteIndicatorTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPORouteIndicatorTestRouteArgs>(
          orElse: () => const PPORouteIndicatorTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i12.PPOPageIndicatorTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOHintTestRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i13.PPOHintTestPage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOPinFieldTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOPinFieldTestRouteArgs>(
          orElse: () => const PPOPinFieldTestRouteArgs());
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: _i14.PPOPinFieldTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    PPOScaffoldDecorationTestRoute.name: (routeData) {
      return _i16.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i15.PPOScaffoldDecorationTestPage(),
        transitionsBuilder:
            _i18.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i16.RouteConfig> get routes => [
        _i16.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i16.RouteConfig(
          TermsAndConditionsDialog.name,
          path: '/terms',
        ),
        _i16.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i16.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding',
        ),
        _i16.RouteConfig(
          CreateAccountRoute.name,
          path: '/new-account',
        ),
        _i16.RouteConfig(
          PPOButtonTestRoute.name,
          path: '/design-system/buttons',
        ),
        _i16.RouteConfig(
          PPOCheckboxTestRoute.name,
          path: '/design-system/checkboxes',
        ),
        _i16.RouteConfig(
          PPOTextFieldTestRoute.name,
          path: '/design-system/text-fields',
        ),
        _i16.RouteConfig(
          PPOGlassContainerTestRoute.name,
          path: '/design-system/glass-container',
        ),
        _i16.RouteConfig(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        ),
        _i16.RouteConfig(
          PPOStampTestRoute.name,
          path: '/design-system/stamps',
        ),
        _i16.RouteConfig(
          PPORouteIndicatorTestRoute.name,
          path: '/design-system/page-indicator',
        ),
        _i16.RouteConfig(
          PPOHintTestRoute.name,
          path: '/design-system/hints',
        ),
        _i16.RouteConfig(
          PPOPinFieldTestRoute.name,
          path: '/design-system/pin-field',
        ),
        _i16.RouteConfig(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i16.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i19.SplashStyle style = _i19.SplashStyle.embracePositivity,
    bool shouldPauseView = false,
    _i17.Key? key,
  }) : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(
            style: style,
            shouldPauseView: shouldPauseView,
            key: key,
          ),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.style = _i19.SplashStyle.embracePositivity,
    this.shouldPauseView = false,
    this.key,
  });

  final _i19.SplashStyle style;

  final bool shouldPauseView;

  final _i17.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{style: $style, shouldPauseView: $shouldPauseView, key: $key}';
  }
}

/// generated route for
/// [_i2.TermsAndConditionsDialog]
class TermsAndConditionsDialog extends _i16.PageRouteInfo<void> {
  const TermsAndConditionsDialog()
      : super(
          TermsAndConditionsDialog.name,
          path: '/terms',
        );

  static const String name = 'TermsAndConditionsDialog';
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i16.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.OnboardingPage]
class OnboardingRoute extends _i16.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    required int stepIndex,
    bool displayPledgeOnly = false,
    _i17.Key? key,
  }) : super(
          OnboardingRoute.name,
          path: '/onboarding',
          args: OnboardingRouteArgs(
            stepIndex: stepIndex,
            displayPledgeOnly: displayPledgeOnly,
            key: key,
          ),
        );

  static const String name = 'OnboardingRoute';
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({
    required this.stepIndex,
    this.displayPledgeOnly = false,
    this.key,
  });

  final int stepIndex;

  final bool displayPledgeOnly;

  final _i17.Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{stepIndex: $stepIndex, displayPledgeOnly: $displayPledgeOnly, key: $key}';
  }
}

/// generated route for
/// [_i5.CreateAccountPage]
class CreateAccountRoute extends _i16.PageRouteInfo<void> {
  const CreateAccountRoute()
      : super(
          CreateAccountRoute.name,
          path: '/new-account',
        );

  static const String name = 'CreateAccountRoute';
}

/// generated route for
/// [_i6.PPOButtonTestPage]
class PPOButtonTestRoute extends _i16.PageRouteInfo<PPOButtonTestRouteArgs> {
  PPOButtonTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPOButtonTestRoute.name,
          path: '/design-system/buttons',
          args: PPOButtonTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOButtonTestRoute';
}

class PPOButtonTestRouteArgs {
  const PPOButtonTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i7.PPOCheckboxTestPage]
class PPOCheckboxTestRoute
    extends _i16.PageRouteInfo<PPOCheckboxTestRouteArgs> {
  PPOCheckboxTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPOCheckboxTestRoute.name,
          path: '/design-system/checkboxes',
          args: PPOCheckboxTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOCheckboxTestRoute';
}

class PPOCheckboxTestRouteArgs {
  const PPOCheckboxTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPOCheckboxTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i8.PPOTextFieldTestPage]
class PPOTextFieldTestRoute extends _i16.PageRouteInfo<void> {
  const PPOTextFieldTestRoute()
      : super(
          PPOTextFieldTestRoute.name,
          path: '/design-system/text-fields',
        );

  static const String name = 'PPOTextFieldTestRoute';
}

/// generated route for
/// [_i9.PPOGlassContainerTestPage]
class PPOGlassContainerTestRoute
    extends _i16.PageRouteInfo<PPOGlassContainerTestRouteArgs> {
  PPOGlassContainerTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPOGlassContainerTestRoute.name,
          path: '/design-system/glass-container',
          args: PPOGlassContainerTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOGlassContainerTestRoute';
}

class PPOGlassContainerTestRouteArgs {
  const PPOGlassContainerTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i10.PPOTypographyTestPage]
class PPOTypographyTestRoute extends _i16.PageRouteInfo<void> {
  const PPOTypographyTestRoute()
      : super(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        );

  static const String name = 'PPOTypographyTestRoute';
}

/// generated route for
/// [_i11.PPOStampTestPage]
class PPOStampTestRoute extends _i16.PageRouteInfo<PPOStampTestRouteArgs> {
  PPOStampTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPOStampTestRoute.name,
          path: '/design-system/stamps',
          args: PPOStampTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOStampTestRoute';
}

class PPOStampTestRouteArgs {
  const PPOStampTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPOStampTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i12.PPOPageIndicatorTestPage]
class PPORouteIndicatorTestRoute
    extends _i16.PageRouteInfo<PPORouteIndicatorTestRouteArgs> {
  PPORouteIndicatorTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPORouteIndicatorTestRoute.name,
          path: '/design-system/page-indicator',
          args: PPORouteIndicatorTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPORouteIndicatorTestRoute';
}

class PPORouteIndicatorTestRouteArgs {
  const PPORouteIndicatorTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPORouteIndicatorTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i13.PPOHintTestPage]
class PPOHintTestRoute extends _i16.PageRouteInfo<void> {
  const PPOHintTestRoute()
      : super(
          PPOHintTestRoute.name,
          path: '/design-system/hints',
        );

  static const String name = 'PPOHintTestRoute';
}

/// generated route for
/// [_i14.PPOPinFieldTestPage]
class PPOPinFieldTestRoute
    extends _i16.PageRouteInfo<PPOPinFieldTestRouteArgs> {
  PPOPinFieldTestRoute({
    int initialPage = 0,
    _i17.Key? key,
  }) : super(
          PPOPinFieldTestRoute.name,
          path: '/design-system/pin-field',
          args: PPOPinFieldTestRouteArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOPinFieldTestRoute';
}

class PPOPinFieldTestRouteArgs {
  const PPOPinFieldTestRouteArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i17.Key? key;

  @override
  String toString() {
    return 'PPOPinFieldTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i15.PPOScaffoldDecorationTestPage]
class PPOScaffoldDecorationTestRoute extends _i16.PageRouteInfo<void> {
  const PPOScaffoldDecorationTestRoute()
      : super(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        );

  static const String name = 'PPOScaffoldDecorationTestRoute';
}
