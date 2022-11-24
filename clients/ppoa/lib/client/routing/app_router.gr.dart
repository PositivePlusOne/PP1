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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;

import '../components/atoms/buttons/ppo_button_test_view.dart' as _i4;
import '../components/atoms/buttons/ppo_checkbox_test_view.dart' as _i5;
import '../components/atoms/containers/ppo_glass_container_test_view.dart'
    as _i6;
import '../components/atoms/page_indicator/ppo_page_indicator_test_view.dart'
    as _i9;
import '../components/atoms/stamps/ppo_stamps_test_view.dart' as _i8;
import '../components/templates/scaffolds/ppo_scaffold_decoration_test_view.dart'
    as _i10;
import '../home/home_page.dart' as _i2;
import '../onboarding/onboarding_page.dart' as _i3;
import '../simulation/views/ppo_typography_test_view.dart' as _i7;
import '../splash/splash_page.dart' as _i1;

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
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.OnboardingPage(),
      );
    },
    PPOButtonTestView.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestViewArgs>(
          orElse: () => const PPOButtonTestViewArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.PPOButtonTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOCheckboxTestView.name: (routeData) {
      final args = routeData.argsAs<PPOCheckboxTestViewArgs>(
          orElse: () => const PPOCheckboxTestViewArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PPOCheckboxTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOGlassContainerTestView.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestViewArgs>(
          orElse: () => const PPOGlassContainerTestViewArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.PPOGlassContainerTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOTypographyTestView.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.PPOTypographyTestView(),
      );
    },
    PPOStampTestView.name: (routeData) {
      final args = routeData.argsAs<PPOStampTestViewArgs>(
          orElse: () => const PPOStampTestViewArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.PPOStampTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPORouteIndicatorTestView.name: (routeData) {
      final args = routeData.argsAs<PPORouteIndicatorTestViewArgs>(
          orElse: () => const PPORouteIndicatorTestViewArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.PPOPageIndicatorTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOScaffoldDecorationTestView.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.PPOScaffoldDecorationTestView(),
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
          PPOButtonTestView.name,
          path: '/design-system/buttons',
        ),
        _i11.RouteConfig(
          PPOCheckboxTestView.name,
          path: '/design-system/checkboxes',
        ),
        _i11.RouteConfig(
          PPOGlassContainerTestView.name,
          path: '/design-system/glass-container',
        ),
        _i11.RouteConfig(
          PPOTypographyTestView.name,
          path: '/design-system/typography',
        ),
        _i11.RouteConfig(
          PPOStampTestView.name,
          path: '/design-system/stamps',
        ),
        _i11.RouteConfig(
          PPORouteIndicatorTestView.name,
          path: '/design-system/page-indicator',
        ),
        _i11.RouteConfig(
          PPOScaffoldDecorationTestView.name,
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
class OnboardingRoute extends _i11.PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/onboarding',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [_i4.PPOButtonTestView]
class PPOButtonTestView extends _i11.PageRouteInfo<PPOButtonTestViewArgs> {
  PPOButtonTestView({
    int initialPage = 0,
    _i12.Key? key,
  }) : super(
          PPOButtonTestView.name,
          path: '/design-system/buttons',
          args: PPOButtonTestViewArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOButtonTestView';
}

class PPOButtonTestViewArgs {
  const PPOButtonTestViewArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i5.PPOCheckboxTestView]
class PPOCheckboxTestView extends _i11.PageRouteInfo<PPOCheckboxTestViewArgs> {
  PPOCheckboxTestView({
    int initialPage = 0,
    _i12.Key? key,
  }) : super(
          PPOCheckboxTestView.name,
          path: '/design-system/checkboxes',
          args: PPOCheckboxTestViewArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOCheckboxTestView';
}

class PPOCheckboxTestViewArgs {
  const PPOCheckboxTestViewArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOCheckboxTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i6.PPOGlassContainerTestView]
class PPOGlassContainerTestView
    extends _i11.PageRouteInfo<PPOGlassContainerTestViewArgs> {
  PPOGlassContainerTestView({
    int initialPage = 0,
    _i12.Key? key,
  }) : super(
          PPOGlassContainerTestView.name,
          path: '/design-system/glass-container',
          args: PPOGlassContainerTestViewArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOGlassContainerTestView';
}

class PPOGlassContainerTestViewArgs {
  const PPOGlassContainerTestViewArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i7.PPOTypographyTestView]
class PPOTypographyTestView extends _i11.PageRouteInfo<void> {
  const PPOTypographyTestView()
      : super(
          PPOTypographyTestView.name,
          path: '/design-system/typography',
        );

  static const String name = 'PPOTypographyTestView';
}

/// generated route for
/// [_i8.PPOStampTestView]
class PPOStampTestView extends _i11.PageRouteInfo<PPOStampTestViewArgs> {
  PPOStampTestView({
    int initialPage = 0,
    _i12.Key? key,
  }) : super(
          PPOStampTestView.name,
          path: '/design-system/stamps',
          args: PPOStampTestViewArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPOStampTestView';
}

class PPOStampTestViewArgs {
  const PPOStampTestViewArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPOStampTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i9.PPOPageIndicatorTestView]
class PPORouteIndicatorTestView
    extends _i11.PageRouteInfo<PPORouteIndicatorTestViewArgs> {
  PPORouteIndicatorTestView({
    int initialPage = 0,
    _i12.Key? key,
  }) : super(
          PPORouteIndicatorTestView.name,
          path: '/design-system/page-indicator',
          args: PPORouteIndicatorTestViewArgs(
            initialPage: initialPage,
            key: key,
          ),
        );

  static const String name = 'PPORouteIndicatorTestView';
}

class PPORouteIndicatorTestViewArgs {
  const PPORouteIndicatorTestViewArgs({
    this.initialPage = 0,
    this.key,
  });

  final int initialPage;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PPORouteIndicatorTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i10.PPOScaffoldDecorationTestView]
class PPOScaffoldDecorationTestView extends _i11.PageRouteInfo<void> {
  const PPOScaffoldDecorationTestView()
      : super(
          PPOScaffoldDecorationTestView.name,
          path: '/design-system/scaffold-decorations',
        );

  static const String name = 'PPOScaffoldDecorationTestView';
}
