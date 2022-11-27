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
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;

import '../components/atoms/buttons/ppo_button_test_page.dart' as _i5;
import '../components/atoms/buttons/ppo_checkbox_test_page.dart' as _i6;
import '../components/atoms/containers/ppo_glass_container_test_page.dart'
    as _i7;
import '../components/atoms/page_indicator/ppo_page_indicator_test_page.dart'
    as _i10;
import '../components/atoms/stamps/ppo_stamps_test_page.dart' as _i9;
import '../components/templates/scaffolds/ppo_scaffold_decoration_test_page.dart'
    as _i11;
import '../home/home_page.dart' as _i2;
import '../onboarding/onboarding_page.dart' as _i3;
import '../registration/create_account_page.dart' as _i4;
import '../simulation/views/ppo_typography_test_page.dart' as _i8;
import '../splash/splash_page.dart' as _i1;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>();
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.OnboardingPage(
          stepIndex: args.stepIndex,
          key: args.key,
        ),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.CreateAccountPage(),
      );
    },
    PPOButtonTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestRouteArgs>(
          orElse: () => const PPOButtonTestRouteArgs());
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PPOButtonTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOCheckboxTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOCheckboxTestRouteArgs>(
          orElse: () => const PPOCheckboxTestRouteArgs());
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.PPOCheckboxTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOGlassContainerTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestRouteArgs>(
          orElse: () => const PPOGlassContainerTestRouteArgs());
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.PPOGlassContainerTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOTypographyTestRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.PPOTypographyTestPage(),
      );
    },
    PPOStampTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPOStampTestRouteArgs>(
          orElse: () => const PPOStampTestRouteArgs());
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.PPOStampTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPORouteIndicatorTestRoute.name: (routeData) {
      final args = routeData.argsAs<PPORouteIndicatorTestRouteArgs>(
          orElse: () => const PPORouteIndicatorTestRouteArgs());
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.PPOPageIndicatorTestPage(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOScaffoldDecorationTestRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.PPOScaffoldDecorationTestPage(),
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i12.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i12.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding',
        ),
        _i12.RouteConfig(
          CreateAccountRoute.name,
          path: '/new-account',
        ),
        _i12.RouteConfig(
          PPOButtonTestRoute.name,
          path: '/design-system/buttons',
        ),
        _i12.RouteConfig(
          PPOCheckboxTestRoute.name,
          path: '/design-system/checkboxes',
        ),
        _i12.RouteConfig(
          PPOGlassContainerTestRoute.name,
          path: '/design-system/glass-container',
        ),
        _i12.RouteConfig(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        ),
        _i12.RouteConfig(
          PPOStampTestRoute.name,
          path: '/design-system/stamps',
        ),
        _i12.RouteConfig(
          PPORouteIndicatorTestRoute.name,
          path: '/design-system/page-indicator',
        ),
        _i12.RouteConfig(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.OnboardingPage]
class OnboardingRoute extends _i12.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    required int stepIndex,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{stepIndex: $stepIndex, key: $key}';
  }
}

/// generated route for
/// [_i4.CreateAccountPage]
class CreateAccountRoute extends _i12.PageRouteInfo<void> {
  const CreateAccountRoute()
      : super(
          CreateAccountRoute.name,
          path: '/new-account',
        );

  static const String name = 'CreateAccountRoute';
}

/// generated route for
/// [_i5.PPOButtonTestPage]
class PPOButtonTestRoute extends _i12.PageRouteInfo<PPOButtonTestRouteArgs> {
  PPOButtonTestRoute({
    int initialPage = 0,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i6.PPOCheckboxTestPage]
class PPOCheckboxTestRoute
    extends _i12.PageRouteInfo<PPOCheckboxTestRouteArgs> {
  PPOCheckboxTestRoute({
    int initialPage = 0,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PPOCheckboxTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i7.PPOGlassContainerTestPage]
class PPOGlassContainerTestRoute
    extends _i12.PageRouteInfo<PPOGlassContainerTestRouteArgs> {
  PPOGlassContainerTestRoute({
    int initialPage = 0,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i8.PPOTypographyTestPage]
class PPOTypographyTestRoute extends _i12.PageRouteInfo<void> {
  const PPOTypographyTestRoute()
      : super(
          PPOTypographyTestRoute.name,
          path: '/design-system/typography',
        );

  static const String name = 'PPOTypographyTestRoute';
}

/// generated route for
/// [_i9.PPOStampTestPage]
class PPOStampTestRoute extends _i12.PageRouteInfo<PPOStampTestRouteArgs> {
  PPOStampTestRoute({
    int initialPage = 0,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PPOStampTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i10.PPOPageIndicatorTestPage]
class PPORouteIndicatorTestRoute
    extends _i12.PageRouteInfo<PPORouteIndicatorTestRouteArgs> {
  PPORouteIndicatorTestRoute({
    int initialPage = 0,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PPORouteIndicatorTestRouteArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i11.PPOScaffoldDecorationTestPage]
class PPOScaffoldDecorationTestRoute extends _i12.PageRouteInfo<void> {
  const PPOScaffoldDecorationTestRoute()
      : super(
          PPOScaffoldDecorationTestRoute.name,
          path: '/design-system/scaffold-decorations',
        );

  static const String name = 'PPOScaffoldDecorationTestRoute';
}
