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
import 'package:flutter/material.dart' as _i3;

// Package imports:
import 'package:auto_route/auto_route.dart' as _i2;

// Project imports:
import '../splash/splash_connector.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i3.GlobalKey<_i3.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SplashConnector.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashConnector());
    }
  };

  @override
  List<_i2.RouteConfig> get routes =>
      [_i2.RouteConfig(SplashConnector.name, path: '/')];
}

/// generated route for
/// [_i1.SplashConnector]
class SplashConnector extends _i2.PageRouteInfo<void> {
  const SplashConnector() : super(SplashConnector.name, path: '/');

  static const String name = 'SplashConnector';
}
