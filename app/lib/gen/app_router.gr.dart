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
    OnboardingEducationRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingEducationRouteArgs>(
          orElse: () => const OnboardingEducationRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingEducationPage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingGuidanceRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingGuidanceRouteArgs>(
          orElse: () => const OnboardingGuidanceRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingGuidancePage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingOurPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingOurPledgeRouteArgs>(
          orElse: () => const OnboardingOurPledgeRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingOurPledgePage(
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
        RouteConfig(
          OnboardingEducationRoute.name,
          path: '/onboarding/education',
        ),
        RouteConfig(
          OnboardingGuidanceRoute.name,
          path: '/onboarding/guidance',
        ),
        RouteConfig(
          OnboardingOurPledgeRoute.name,
          path: '/onboarding/our-pledge',
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

/// generated route for
/// [OnboardingEducationPage]
class OnboardingEducationRoute
    extends PageRouteInfo<OnboardingEducationRouteArgs> {
  OnboardingEducationRoute({
    OnboardingStyle style = OnboardingStyle.includeFeatures,
    Key? key,
  }) : super(
          OnboardingEducationRoute.name,
          path: '/onboarding/education',
          args: OnboardingEducationRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingEducationRoute';
}

class OnboardingEducationRouteArgs {
  const OnboardingEducationRouteArgs({
    this.style = OnboardingStyle.includeFeatures,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingEducationRouteArgs{style: $style, key: $key}';
  }
}

/// generated route for
/// [OnboardingGuidancePage]
class OnboardingGuidanceRoute
    extends PageRouteInfo<OnboardingGuidanceRouteArgs> {
  OnboardingGuidanceRoute({
    OnboardingStyle style = OnboardingStyle.includeFeatures,
    Key? key,
  }) : super(
          OnboardingGuidanceRoute.name,
          path: '/onboarding/guidance',
          args: OnboardingGuidanceRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingGuidanceRoute';
}

class OnboardingGuidanceRouteArgs {
  const OnboardingGuidanceRouteArgs({
    this.style = OnboardingStyle.includeFeatures,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingGuidanceRouteArgs{style: $style, key: $key}';
  }
}

/// generated route for
/// [OnboardingOurPledgePage]
class OnboardingOurPledgeRoute
    extends PageRouteInfo<OnboardingOurPledgeRouteArgs> {
  OnboardingOurPledgeRoute({
    OnboardingStyle style = OnboardingStyle.includeFeatures,
    Key? key,
  }) : super(
          OnboardingOurPledgeRoute.name,
          path: '/onboarding/our-pledge',
          args: OnboardingOurPledgeRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingOurPledgeRoute';
}

class OnboardingOurPledgeRouteArgs {
  const OnboardingOurPledgeRouteArgs({
    this.style = OnboardingStyle.includeFeatures,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingOurPledgeRouteArgs{style: $style, key: $key}';
  }
}
