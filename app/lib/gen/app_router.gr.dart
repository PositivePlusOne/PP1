// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: SplashPage(
          key: args.key,
          style: args.style,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingWelcomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const OnboardingWelcomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingConnectRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingConnectRouteArgs>(
          orElse: () => const OnboardingConnectRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingConnectPage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        RouteConfig(
          OnboardingWelcomeRoute.name,
          path: '/onboarding/welcome',
        ),
        RouteConfig(
          OnboardingConnectRoute.name,
          path: '/onboarding/connect',
        ),
      ];
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    Key? key,
    SplashStyle style = SplashStyle.embracePositivity,
  }) : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(
            key: key,
            style: style,
          ),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.style = SplashStyle.embracePositivity,
  });

  final Key? key;

  final SplashStyle style;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, style: $style}';
  }
}

/// generated route for
/// [OnboardingWelcomePage]
class OnboardingWelcomeRoute extends PageRouteInfo<void> {
  const OnboardingWelcomeRoute()
      : super(
          OnboardingWelcomeRoute.name,
          path: '/onboarding/welcome',
        );

  static const String name = 'OnboardingWelcomeRoute';
}

/// generated route for
/// [OnboardingConnectPage]
class OnboardingConnectRoute extends PageRouteInfo<OnboardingConnectRouteArgs> {
  OnboardingConnectRoute({
    OnboardingStyle style = OnboardingStyle.includeFeatures,
    Key? key,
  }) : super(
          OnboardingConnectRoute.name,
          path: '/onboarding/connect',
          args: OnboardingConnectRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingConnectRoute';
}

class OnboardingConnectRouteArgs {
  const OnboardingConnectRouteArgs({
    this.style = OnboardingStyle.includeFeatures,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingConnectRouteArgs{style: $style, key: $key}';
  }
}
