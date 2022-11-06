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
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

// Flutter imports:
import 'package:flutter/material.dart' as _i7;

// Package imports:
import 'package:auto_route/auto_route.dart' as _i6;

// Project imports:
import '../components/atoms/buttons/ppo_button_test_view.dart' as _i3;
import '../components/atoms/containers/ppo_glass_container_test_view.dart' as _i4;
import '../components/atoms/stamps/ppo_stamps_test_view.dart' as _i5;
import '../home/home_page.dart' as _i2;
import '../splash/splash_page.dart' as _i1;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    PPOButtonTestView.name: (routeData) {
      final args = routeData.argsAs<PPOButtonTestViewArgs>(orElse: () => const PPOButtonTestViewArgs());
      return _i6.MaterialPageX<dynamic>(
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
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.PPOCheckboxTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    PPOGlassContainerTestView.name: (routeData) {
      final args = routeData.argsAs<PPOGlassContainerTestViewArgs>(orElse: () => const PPOGlassContainerTestViewArgs());
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PPOGlassContainerTestView(
          initialPage: args.initialPage,
          key: args.key,
        ),
      );
    },
    DesignSystemStampView.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.PPOStampTestView(),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SplashRoute.name,
          path: '/',
          meta: <String, dynamic>{'Simulator Group': 'Other'},
        ),
        _i6.RouteConfig(
          HomeRoute.name,
          path: '/home',
          meta: <String, dynamic>{'Simulator Group': 'Other'},
        ),
        _i6.RouteConfig(
          PPOButtonTestView.name,
          path: '/design-system/buttons',
          meta: <String, dynamic>{'Simulator Group': 'Design System'},
        ),
        _i6.RouteConfig(
          PPOGlassContainerTestView.name,
          path: '/design-system/glass-container',
          meta: <String, dynamic>{'Simulator Group': 'Design System'},
        ),
        _i6.RouteConfig(
          DesignSystemStampView.name,
          path: '/design-system/stamps',
          meta: <String, dynamic>{'Simulator Group': 'Design System'},
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.PPOButtonTestView]
class PPOButtonTestView extends _i6.PageRouteInfo<PPOButtonTestViewArgs> {
  PPOButtonTestView({
    int initialPage = 0,
    _i7.Key? key,
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

  final _i7.Key? key;

  @override
  String toString() {
    return 'PPOButtonTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i4.PPOGlassContainerTestView]
class PPOGlassContainerTestView extends _i6.PageRouteInfo<PPOGlassContainerTestViewArgs> {
  PPOGlassContainerTestView({
    int initialPage = 0,
    _i7.Key? key,
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

  final _i7.Key? key;

  @override
  String toString() {
    return 'PPOGlassContainerTestViewArgs{initialPage: $initialPage, key: $key}';
  }
}

/// generated route for
/// [_i5.DesignSystemStampView]
class DesignSystemStampView extends _i6.PageRouteInfo<void> {
  const DesignSystemStampView()
      : super(
          DesignSystemStampView.name,
          path: '/design-system/stamps',
        );

  static const String name = 'DesignSystemStampView';
}
