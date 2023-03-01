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
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.splashGuard,
    required this.pledgeGuard,
    required this.authenticationGuard,
    required this.notificationGuard,
    required this.biometricsGuard,
    required this.profileGuard,
  }) : super(navigatorKey);

  final SplashGuard splashGuard;

  final PledgeGuard pledgeGuard;

  final AuthenticationGuard authenticationGuard;

  final NotificationGuard notificationGuard;

  final BiometricsGuard biometricsGuard;

  final ProfileGuard profileGuard;

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
    OnboardingYourPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingYourPledgeRouteArgs>(
          orElse: () => const OnboardingYourPledgeRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingYourPledgePage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationAccountRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationEmailEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationEmailEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPasswordEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPasswordEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPhoneEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPhoneVerificationRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneVerificationPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationAccountSetupRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountSetupPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TermsAndConditionsRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const TermsAndConditionsPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    NotificationPreferencesRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const NotificationPreferencesPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    BiometricsPreferencesRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const BiometricsPreferencesPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ErrorRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: ErrorPage(
          errorMessage: args.errorMessage,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SearchRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const SearchPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ChatListRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatListPage()),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ChatRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatPage()),
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
          guards: [splashGuard],
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
        RouteConfig(
          OnboardingYourPledgeRoute.name,
          path: '/onboarding/your-pledge',
        ),
        RouteConfig(
          RegistrationAccountRoute.name,
          path: '/registration/account',
        ),
        RouteConfig(
          RegistrationEmailEntryRoute.name,
          path: '/registration/create/email',
        ),
        RouteConfig(
          RegistrationPasswordEntryRoute.name,
          path: '/registration/create/password',
        ),
        RouteConfig(
          RegistrationPhoneEntryRoute.name,
          path: '/registration/create/phone',
        ),
        RouteConfig(
          RegistrationPhoneVerificationRoute.name,
          path: '/registration/create/phone/verify',
        ),
        RouteConfig(
          RegistrationAccountSetupRoute.name,
          path: '/registration/profile/start',
        ),
        RouteConfig(
          TermsAndConditionsRoute.name,
          path: '/terms',
        ),
        RouteConfig(
          NotificationPreferencesRoute.name,
          path: '/notifications',
        ),
        RouteConfig(
          BiometricsPreferencesRoute.name,
          path: '/biometrics',
        ),
        RouteConfig(
          ErrorRoute.name,
          path: '/error',
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/home',
          guards: [
            pledgeGuard,
            authenticationGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
          ],
        ),
        RouteConfig(
          SearchRoute.name,
          path: '/search',
          guards: [
            pledgeGuard,
            authenticationGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
          ],
        ),
        RouteConfig(
          ChatListRoute.name,
          path: '/chat/list',
        ),
        RouteConfig(
          ChatRoute.name,
          path: '/chat/current',
        ),
        RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
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

/// generated route for
/// [OnboardingYourPledgePage]
class OnboardingYourPledgeRoute
    extends PageRouteInfo<OnboardingYourPledgeRouteArgs> {
  OnboardingYourPledgeRoute({
    OnboardingStyle style = OnboardingStyle.includeFeatures,
    Key? key,
  }) : super(
          OnboardingYourPledgeRoute.name,
          path: '/onboarding/your-pledge',
          args: OnboardingYourPledgeRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingYourPledgeRoute';
}

class OnboardingYourPledgeRouteArgs {
  const OnboardingYourPledgeRouteArgs({
    this.style = OnboardingStyle.includeFeatures,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingYourPledgeRouteArgs{style: $style, key: $key}';
  }
}

/// generated route for
/// [RegistrationAccountPage]
class RegistrationAccountRoute extends PageRouteInfo<void> {
  const RegistrationAccountRoute()
      : super(
          RegistrationAccountRoute.name,
          path: '/registration/account',
        );

  static const String name = 'RegistrationAccountRoute';
}

/// generated route for
/// [RegistrationEmailEntryPage]
class RegistrationEmailEntryRoute extends PageRouteInfo<void> {
  const RegistrationEmailEntryRoute()
      : super(
          RegistrationEmailEntryRoute.name,
          path: '/registration/create/email',
        );

  static const String name = 'RegistrationEmailEntryRoute';
}

/// generated route for
/// [RegistrationPasswordEntryPage]
class RegistrationPasswordEntryRoute extends PageRouteInfo<void> {
  const RegistrationPasswordEntryRoute()
      : super(
          RegistrationPasswordEntryRoute.name,
          path: '/registration/create/password',
        );

  static const String name = 'RegistrationPasswordEntryRoute';
}

/// generated route for
/// [RegistrationPhoneEntryPage]
class RegistrationPhoneEntryRoute extends PageRouteInfo<void> {
  const RegistrationPhoneEntryRoute()
      : super(
          RegistrationPhoneEntryRoute.name,
          path: '/registration/create/phone',
        );

  static const String name = 'RegistrationPhoneEntryRoute';
}

/// generated route for
/// [RegistrationPhoneVerificationPage]
class RegistrationPhoneVerificationRoute extends PageRouteInfo<void> {
  const RegistrationPhoneVerificationRoute()
      : super(
          RegistrationPhoneVerificationRoute.name,
          path: '/registration/create/phone/verify',
        );

  static const String name = 'RegistrationPhoneVerificationRoute';
}

/// generated route for
/// [RegistrationAccountSetupPage]
class RegistrationAccountSetupRoute extends PageRouteInfo<void> {
  const RegistrationAccountSetupRoute()
      : super(
          RegistrationAccountSetupRoute.name,
          path: '/registration/profile/start',
        );

  static const String name = 'RegistrationAccountSetupRoute';
}

/// generated route for
/// [TermsAndConditionsPage]
class TermsAndConditionsRoute extends PageRouteInfo<void> {
  const TermsAndConditionsRoute()
      : super(
          TermsAndConditionsRoute.name,
          path: '/terms',
        );

  static const String name = 'TermsAndConditionsRoute';
}

/// generated route for
/// [NotificationPreferencesPage]
class NotificationPreferencesRoute extends PageRouteInfo<void> {
  const NotificationPreferencesRoute()
      : super(
          NotificationPreferencesRoute.name,
          path: '/notifications',
        );

  static const String name = 'NotificationPreferencesRoute';
}

/// generated route for
/// [BiometricsPreferencesPage]
class BiometricsPreferencesRoute extends PageRouteInfo<void> {
  const BiometricsPreferencesRoute()
      : super(
          BiometricsPreferencesRoute.name,
          path: '/biometrics',
        );

  static const String name = 'BiometricsPreferencesRoute';
}

/// generated route for
/// [ErrorPage]
class ErrorRoute extends PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    required String errorMessage,
    Key? key,
  }) : super(
          ErrorRoute.name,
          path: '/error',
          args: ErrorRouteArgs(
            errorMessage: errorMessage,
            key: key,
          ),
        );

  static const String name = 'ErrorRoute';
}

class ErrorRouteArgs {
  const ErrorRouteArgs({
    required this.errorMessage,
    this.key,
  });

  final String errorMessage;

  final Key? key;

  @override
  String toString() {
    return 'ErrorRouteArgs{errorMessage: $errorMessage, key: $key}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: '/search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [ChatListPage]
class ChatListRoute extends PageRouteInfo<void> {
  const ChatListRoute()
      : super(
          ChatListRoute.name,
          path: '/chat/list',
        );

  static const String name = 'ChatListRoute';
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute()
      : super(
          ChatRoute.name,
          path: '/chat/current',
        );

  static const String name = 'ChatRoute';
}
