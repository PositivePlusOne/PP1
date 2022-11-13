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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../components/atoms/buttons/ppo_button_test_view.dart' as _i3;
import '../components/atoms/buttons/ppo_checkbox_test_view.dart' as _i4;
import '../components/atoms/containers/ppo_glass_container_test_view.dart'
    as _i5;
import '../components/atoms/stamps/ppo_stamps_test_view.dart' as _i7;
import '../components/templates/scaffolds/ppo_scaffold_test_view.dart' as _i8;
import '../home/home_page.dart' as _i2;
import '../simulation/views/ppo_typography_test_view.dart' as _i6;
import '../splash/splash_page.dart' as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    PPOButtonTestView.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestViewArgs>(
          orElse: () => const PPOButtonTestViewArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.PPOButtonTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOCheckboxTestView.name: (routeData) {
      final args = routeData.argsAs<PPOCheckboxTestViewArgs>(
          orElse: () => const PPOCheckboxTestViewArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.PPOCheckboxTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOGlassContainerTestView.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestViewArgs>(
          orElse: () => const PPOGlassContainerTestViewArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PPOGlassContainerTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOTypographyTestView.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.PPOTypographyTestView(),
      );
    },
    PPOStampTestView.name: (routeData) {
      final args = routeData.argsAs<PPOStampTestViewArgs>(
          orElse: () => const PPOStampTestViewArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.PPOStampTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOScaffoldTestView.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.PPOScaffoldTestView(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i9.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i9.RouteConfig(
          PPOButtonTestView.name,
          path: '/design-system/buttons',
        ),
        _i9.RouteConfig(
          PPOCheckboxTestView.name,
          path: '/design-system/checkboxes',
        ),
        _i9.RouteConfig(
          PPOGlassContainerTestView.name,
          path: '/design-system/glass-container',
        ),
        _i9.RouteConfig(
          PPOTypographyTestView.name,
          path: '/design-system/typography',
        ),
        _i9.RouteConfig(
          PPOStampTestView.name,
          path: '/design-system/stamps',
        ),
        _i9.RouteConfig(
          PPOScaffoldTestView.name,
          path: '/design-system/scaffold',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.PPOButtonTestView]
class PPOButtonTestView extends _i9.PageRouteInfo<PPOButtonTestViewArgs> {
  PPOButtonTestView({
    int initialPage = 0,
    _i10.Key? key,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i4.PPOCheckboxTestView]
class PPOCheckboxTestView extends _i9.PageRouteInfo<PPOCheckboxTestViewArgs> {
  PPOCheckboxTestView({
    int initialPage = 0,
    _i10.Key? key,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'PPOCheckboxTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i5.PPOGlassContainerTestView]
class PPOGlassContainerTestView
    extends _i9.PageRouteInfo<PPOGlassContainerTestViewArgs> {
  PPOGlassContainerTestView({
    int initialPage = 0,
    _i10.Key? key,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i6.PPOTypographyTestView]
class PPOTypographyTestView extends _i9.PageRouteInfo<void> {
  const PPOTypographyTestView()
      : super(
          PPOTypographyTestView.name,
          path: '/design-system/typography',
        );

  static const String name = 'PPOTypographyTestView';
}

/// generated route for
/// [_i7.PPOStampTestView]
class PPOStampTestView extends _i9.PageRouteInfo<PPOStampTestViewArgs> {
  PPOStampTestView({
    int initialPage = 0,
    _i10.Key? key,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'PPOStampTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i8.PPOScaffoldTestView]
class PPOScaffoldTestView extends _i9.PageRouteInfo<void> {
  const PPOScaffoldTestView()
      : super(
          PPOScaffoldTestView.name,
          path: '/design-system/scaffold',
        );

  static const String name = 'PPOScaffoldTestView';
}
