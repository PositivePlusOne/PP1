// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/routing/radial_transition_builder.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import '../dialogs/terms_and_conditions_dialog.dart';
import '../onboarding/onboarding_page.dart';
import '../registration/create_account_page.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  preferRelativeImports: true,
  transitionsBuilder: RadialTransitionsBuilder.radialTransition,
  opaque: false,
  durationInMilliseconds: RadialTransitionsBuilder.durationMillis,
  routes: <AutoRoute>[
    //* Splash
    AutoRoute(page: SplashPage, initial: true),

    //* Dialogs
    AutoRoute(page: TermsAndConditionsDialog, path: '/terms'),

    //* Onboarding
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: OnboardingPage, path: '/onboarding'),

    //* Registration, Signin, and Password Reset
    AutoRoute(page: CreateAccountPage, path: '/new-account'),
  ],
)
class $AppRouter {}
