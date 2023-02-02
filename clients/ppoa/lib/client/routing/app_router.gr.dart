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
import 'package:flutter/material.dart' as _i7;

// Package imports:
import 'package:auto_route/auto_route.dart' as _i6;

// Project imports:
import '../dialogs/terms_and_conditions_dialog.dart' as _i2;
import '../home/home_page.dart' as _i3;
import '../onboarding/onboarding_page.dart' as _i4;
import '../registration/create_account_page.dart' as _i5;
import '../splash/splash_lifecycle.dart' as _i9;
import '../splash/splash_page.dart' as _i1;
import 'radial_transition_builder.dart' as _i8;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SplashPage(
          style: args.style,
          shouldPauseView: args.shouldPauseView,
          key: args.key,
        ),
        transitionsBuilder:
            _i8.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    TermsAndConditionsDialog.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.TermsAndConditionsDialog(),
        transitionsBuilder:
            _i8.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
        transitionsBuilder:
            _i8.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>();
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.OnboardingPage(
          stepIndex: args.stepIndex,
          displayPledgeOnly: args.displayPledgeOnly,
          key: args.key,
        ),
        transitionsBuilder:
            _i8.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.CreateAccountPage(),
        transitionsBuilder:
            _i8.RadialTransitionsBuilder.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: false,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          TermsAndConditionsDialog.name,
          path: '/terms',
        ),
        _i6.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i6.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding',
        ),
        _i6.RouteConfig(
          CreateAccountRoute.name,
          path: '/new-account',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i9.SplashStyle style = _i9.SplashStyle.embracePositivity,
    bool shouldPauseView = false,
    _i7.Key? key,
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
    this.style = _i9.SplashStyle.embracePositivity,
    this.shouldPauseView = false,
    this.key,
  });

  final _i9.SplashStyle style;

  final bool shouldPauseView;

  final _i7.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{style: $style, shouldPauseView: $shouldPauseView, key: $key}';
  }
}

/// generated route for
/// [_i2.TermsAndConditionsDialog]
class TermsAndConditionsDialog extends _i6.PageRouteInfo<void> {
  const TermsAndConditionsDialog()
      : super(
          TermsAndConditionsDialog.name,
          path: '/terms',
        );

  static const String name = 'TermsAndConditionsDialog';
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.OnboardingPage]
class OnboardingRoute extends _i6.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    required int stepIndex,
    bool displayPledgeOnly = false,
    _i7.Key? key,
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

  final _i7.Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{stepIndex: $stepIndex, displayPledgeOnly: $displayPledgeOnly, key: $key}';
  }
}

/// generated route for
/// [_i5.CreateAccountPage]
class CreateAccountRoute extends _i6.PageRouteInfo<void> {
  const CreateAccountRoute()
      : super(
          CreateAccountRoute.name,
          path: '/new-account',
        );

  static const String name = 'CreateAccountRoute';
}
