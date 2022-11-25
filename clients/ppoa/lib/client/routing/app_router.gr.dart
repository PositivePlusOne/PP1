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

// Flutter imports:
import 'package:flutter/material.dart' as _i12;

// Package imports:
import 'package:auto_route/auto_route.dart' as _i11;

// Project imports:
import '../components/atoms/buttons/ppo_button_test_page.dart' as _i4;
import '../components/atoms/buttons/ppo_checkbox_test_page.dart' as _i5;
import '../components/atoms/stamps/ppo_stamps_test_page.dart' as _i8;
import '../home/home_page.dart' as _i2;
import '../onboarding/onboarding_page.dart' as _i3;
import '../simulation/views/ppo_typography_test_page.dart' as _i7;
import '../splash/splash_page.dart' as _i1;

import '../components/atoms/containers/ppo_glass_container_test_page.dart'
    as _i6;
import '../components/atoms/page_indicator/ppo_page_indicator_test_page.dart'
    as _i9;
import '../components/templates/scaffolds/ppo_scaffold_decoration_test_page.dart'
    as _i10;

class AppRouter extends _i11.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>();
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.OnboardingPage(
          stepIndex: args.stepIndex,
          key: args.key,
        ),
      );
    },
    PPOButtonTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestRouteArgs>(
          orElse: () => const PPOButtonTestRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.PPOButtonTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOCheckboxTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOCheckboxTestRouteArgs>(
          orElse: () => const PPOCheckboxTestRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PPOCheckboxTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOGlassContainerTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestRouteArgs>(
          orElse: () => const PPOGlassContainerTestRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.PPOGlassContainerTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOTypographyTestRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.PPOTypographyTestPage(),
      );
    },
    PPOStampTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOStampTestRouteArgs>(
          orElse: () => const PPOStampTestRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.PPOStampTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPORouteIndicatorTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPORouteIndicatorTestRouteArgs>(
          orElse: () => const PPORouteIndicatorTestRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.PPOPageIndicatorTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOScaffoldDecorationTestRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.PPOScaffoldDecorationTestPage(),
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i11.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i11.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding',
        ),
        _i11.RouteConfig(
          PPOButtonTestRoute.name,
          path: '/design-system/buttons',
        ),
        _i11.RouteConfig(
          PPOCheckboxTestRoute.name,
          path: '/design-system/checkboxes',
        ),
        _i11.RouteConfig(
          PPOGlassContainerTestRoute.name,
          path: '/design-system/glass-container',
        ),
        _i11.RouteConfig(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        ),
        _i11.RouteConfig(
          PPOStampTestRoute.name,
          path: '/design-system/stamps',
        ),
        _i11.RouteConfig(
          PPORouteIndicatorTestRoute.name,
          path: '/design-system/page-indicator',
        ),
        _i11.RouteConfig(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.OnboardingPage]
class OnboardingRoute extends _i11.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    required int stepIndex,
    _i12.Key? key,
  }) : super(
          OnboardingRoute.name,
          path: '/onboarding',
          args: OnboardingRouteArgs(
            stepIndex: stepIndex,
            key: key,
          ),
        );

  static const String name = 'OnboardingRoute';
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({
    required this.stepIndex,
    this.key,
  });

  final int stepIndex;

  final _i12.Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{stepIndex: $stepIndex, key: $key}';
  }
}

/// generated route for
/// [_i4.PPOButtonTestPage]
class PPOButtonTestRoute extends _i11.PageRouteInfo<PPOButtonTestRouteArgs> {
  PPOButtonTestRoute({
    int initialPage = 0,
    _i12.Key? key,
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i5.PPOCheckboxTestPage]
class PPOCheckboxTestRoute
    extends _i11.PageRouteInfo<PPOCheckboxTestRouteArgs> {
  PPOCheckboxTestRoute({
    int initialPage = 0,
    _i12.Key? key,
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOCheckboxTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i6.PPOGlassContainerTestPage]
class PPOGlassContainerTestRoute
    extends _i11.PageRouteInfo<PPOGlassContainerTestRouteArgs> {
  PPOGlassContainerTestRoute({
    int initialPage = 0,
    _i12.Key? key,
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i7.PPOTypographyTestPage]
class PPOTypographyTestRoute extends _i11.PageRouteInfo<void> {
  const PPOTypographyTestRoute()
      : super(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        );

  static const String name = 'PPOTypographyTestRoute';
}

/// generated route for
/// [_i8.PPOStampTestPage]
class PPOStampTestRoute extends _i11.PageRouteInfo<PPOStampTestRouteArgs> {
  PPOStampTestRoute({
    int initialPage = 0,
    _i12.Key? key,
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOStampTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i9.PPOPageIndicatorTestPage]
class PPORouteIndicatorTestRoute
    extends _i11.PageRouteInfo<PPORouteIndicatorTestRouteArgs> {
  PPORouteIndicatorTestRoute({
    int initialPage = 0,
    _i12.Key? key,
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPORouteIndicatorTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i10.PPOScaffoldDecorationTestPage]
class PPOScaffoldDecorationTestRoute extends _i11.PageRouteInfo<void> {
  const PPOScaffoldDecorationTestRoute()
      : super(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        );

  static const String name = 'PPOScaffoldDecorationTestRoute';
}
