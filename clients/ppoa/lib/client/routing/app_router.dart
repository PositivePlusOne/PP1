// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox_test_page.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container_test_page.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator_test_page.dart';
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/routing/radial_transition_builder.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import '../components/atoms/buttons/ppo_button_test_page.dart';
import '../components/atoms/stamps/ppo_stamps_test_page.dart';
import '../components/templates/scaffolds/ppo_scaffold_decoration_test_page.dart';
import '../onboarding/onboarding_page.dart';
import '../registration/create_account_page.dart';
import '../simulation/views/ppo_typography_test_page.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  preferRelativeImports: true,
  transitionsBuilder: RadialTransitionsBuilder.radialTransition,
  opaque: false,
  durationInMilliseconds: RadialTransitionsBuilder.durationMillis,
  routes: <AutoRoute>[
    //* Splash
    AutoRoute(page: SplashPage, initial: true),

    //* Onboarding
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: OnboardingPage, path: '/onboarding'),

    //* Registration, Signin, and Password Reset
    AutoRoute(page: CreateAccountPage, path: '/new-account'),

    //* Design System Routes (Atom)
    AutoRoute(page: PPOButtonTestPage, path: '/design-system/buttons'),
    AutoRoute(page: PPOCheckboxTestPage, path: '/design-system/checkboxes'),
    AutoRoute(page: PPOGlassContainerTestPage, path: '/design-system/glass-container'),
    AutoRoute(page: PPOTypographyTestPage, path: '/design-system/typography'),
    AutoRoute(page: PPOStampTestPage, path: '/design-system/stamps'),
    AutoRoute(page: PPOPageIndicatorTestPage, path: '/design-system/page-indicator'),

    //* Design System Routes (Templates)
    AutoRoute(page: PPOScaffoldDecorationTestPage, path: '/design-system/scaffold-decorations'),
  ],
)
class $AppRouter {}
