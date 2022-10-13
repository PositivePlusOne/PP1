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
import 'package:flutter/material.dart' as _i5;

// Package imports:
import 'package:auto_route/auto_route.dart' as _i4;

// Project imports:
import '../home/home_page.dart' as _i2;
import '../simulation/views/design_system_buttons_view.dart' as _i3;
import '../splash/splash_page.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashPage());
    },
    HomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomePage());
    },
    DesignSystemButtonsView.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.DesignSystemButtonsView());
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(SplashRoute.name,
            path: '/', meta: <String, dynamic>{'Simulator Group': 'Other'}),
        _i4.RouteConfig(HomeRoute.name,
            path: '/home', meta: <String, dynamic>{'Simulator Group': 'Other'}),
        _i4.RouteConfig(DesignSystemButtonsView.name,
            path: '/design-system/buttons',
            meta: <String, dynamic>{'Simulator Group': 'Design System'})
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i4.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/home');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.DesignSystemButtonsView]
class DesignSystemButtonsView extends _i4.PageRouteInfo<void> {
  const DesignSystemButtonsView()
      : super(DesignSystemButtonsView.name, path: '/design-system/buttons');

  static const String name = 'DesignSystemButtonsView';
}
