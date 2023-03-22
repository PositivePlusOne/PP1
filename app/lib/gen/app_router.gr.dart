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
    required this.authenticationGuard,
    required this.pledgeGuard,
    required this.authProviderGuard,
    required this.notificationGuard,
    required this.biometricsGuard,
    required this.profileGuard,
    required this.developmentGuard,
  }) : super(navigatorKey);

  final SplashGuard splashGuard;

  final AuthenticationGuard authenticationGuard;

  final PledgeGuard pledgeGuard;

  final AuthProviderGuard authProviderGuard;

  final NotificationGuard notificationGuard;

  final BiometricsGuard biometricsGuard;

  final ProfileGuard profileGuard;

  final DevelopmentGuard developmentGuard;

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
    HIVStatusRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const HIVStatusPage(),
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
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          userId: args.userId,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileNameEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileNameEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileDisplayNameEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileDisplayNameEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageWelcomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageWelcomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImagePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageSuccessRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageSuccessPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageDialogRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageDialogPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileEditSettingsRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileEditSettingsPage(),
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
    AccountRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountPage(),
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
    DevelopmentRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const DevelopmentPage(),
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
          HIVStatusRoute.name,
          path: '/registration/profile/hiv-status',
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
          NotificationPreferencesRoute.name,
          path: '/notifications',
        ),
        RouteConfig(
          BiometricsPreferencesRoute.name,
          path: '/biometrics',
        ),
        RouteConfig(
          ProfileRoute.name,
          path: '/profile/view/:userId',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileNameEntryRoute.name,
          path: '/profile/setup/name',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileDisplayNameEntryRoute.name,
          path: '/profile/setup/display-name',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileImageWelcomeRoute.name,
          path: '/profile/setup/image/welcome',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileImageRoute.name,
          path: '/profile/setup/image',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileImageSuccessRoute.name,
          path: '/profile/setup/image/success',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileImageDialogRoute.name,
          path: '/profile/setup/image/help',
          guards: [authenticationGuard],
        ),
        RouteConfig(
          ProfileEditSettingsRoute.name,
          path: '/profile/edit-settings',
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/home',
          guards: [
            pledgeGuard,
            authProviderGuard,
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
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
            authenticationGuard,
          ],
        ),
        RouteConfig(
          AccountRoute.name,
          path: '/account',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
            authenticationGuard,
          ],
        ),
        RouteConfig(
          ChatListRoute.name,
          path: '/chat/list',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
            authenticationGuard,
          ],
        ),
        RouteConfig(
          ChatRoute.name,
          path: '/chat/current',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileGuard,
            authenticationGuard,
          ],
        ),
        RouteConfig(
          TermsAndConditionsRoute.name,
          path: '/terms',
        ),
        RouteConfig(
          ErrorRoute.name,
          path: '/error',
        ),
        RouteConfig(
          DevelopmentRoute.name,
          path: '/devtools',
          guards: [developmentGuard],
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
    OnboardingStyle style = OnboardingStyle.home,
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
    this.style = OnboardingStyle.home,
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
    OnboardingStyle style = OnboardingStyle.home,
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
    this.style = OnboardingStyle.home,
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
    OnboardingStyle style = OnboardingStyle.home,
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
    this.style = OnboardingStyle.home,
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
    OnboardingStyle style = OnboardingStyle.home,
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
    this.style = OnboardingStyle.home,
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
    OnboardingStyle style = OnboardingStyle.home,
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
    this.style = OnboardingStyle.home,
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
/// [HIVStatusPage]
class HIVStatusRoute extends PageRouteInfo<void> {
  const HIVStatusRoute()
      : super(
          HIVStatusRoute.name,
          path: '/registration/profile/hiv-status',
        );

  static const String name = 'HIVStatusRoute';
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
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required String userId,
    Key? key,
  }) : super(
          ProfileRoute.name,
          path: '/profile/view/:userId',
          args: ProfileRouteArgs(
            userId: userId,
            key: key,
          ),
        );

  static const String name = 'ProfileRoute';
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [ProfileNameEntryPage]
class ProfileNameEntryRoute extends PageRouteInfo<void> {
  const ProfileNameEntryRoute()
      : super(
          ProfileNameEntryRoute.name,
          path: '/profile/setup/name',
        );

  static const String name = 'ProfileNameEntryRoute';
}

/// generated route for
/// [ProfileDisplayNameEntryPage]
class ProfileDisplayNameEntryRoute extends PageRouteInfo<void> {
  const ProfileDisplayNameEntryRoute()
      : super(
          ProfileDisplayNameEntryRoute.name,
          path: '/profile/setup/display-name',
        );

  static const String name = 'ProfileDisplayNameEntryRoute';
}

/// generated route for
/// [ProfileImageWelcomePage]
class ProfileImageWelcomeRoute extends PageRouteInfo<void> {
  const ProfileImageWelcomeRoute()
      : super(
          ProfileImageWelcomeRoute.name,
          path: '/profile/setup/image/welcome',
        );

  static const String name = 'ProfileImageWelcomeRoute';
}

/// generated route for
/// [ProfileImagePage]
class ProfileImageRoute extends PageRouteInfo<void> {
  const ProfileImageRoute()
      : super(
          ProfileImageRoute.name,
          path: '/profile/setup/image',
        );

  static const String name = 'ProfileImageRoute';
}

/// generated route for
/// [ProfileImageSuccessPage]
class ProfileImageSuccessRoute extends PageRouteInfo<void> {
  const ProfileImageSuccessRoute()
      : super(
          ProfileImageSuccessRoute.name,
          path: '/profile/setup/image/success',
        );

  static const String name = 'ProfileImageSuccessRoute';
}

/// generated route for
/// [ProfileImageDialogPage]
class ProfileImageDialogRoute extends PageRouteInfo<void> {
  const ProfileImageDialogRoute()
      : super(
          ProfileImageDialogRoute.name,
          path: '/profile/setup/image/help',
        );

  static const String name = 'ProfileImageDialogRoute';
}

/// generated route for
/// [ProfileEditSettingsPage]
class ProfileEditSettingsRoute extends PageRouteInfo<void> {
  const ProfileEditSettingsRoute()
      : super(
          ProfileEditSettingsRoute.name,
          path: '/profile/edit-settings',
        );

  static const String name = 'ProfileEditSettingsRoute';
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
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute()
      : super(
          AccountRoute.name,
          path: '/account',
        );

  static const String name = 'AccountRoute';
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
/// [DevelopmentPage]
class DevelopmentRoute extends PageRouteInfo<void> {
  const DevelopmentRoute()
      : super(
          DevelopmentRoute.name,
          path: '/devtools',
        );

  static const String name = 'DevelopmentRoute';
}
