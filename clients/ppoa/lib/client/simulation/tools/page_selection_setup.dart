// Project imports:
import 'package:ppoa/business/actions/onboarding/preload_onboarding_steps_action.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';

final Map<String, dynamic> kSimulationRoutes = <String, dynamic>{
  'Splash': {
    'Splash (Embrace Positivity)': {
      'route': SplashRoute(style: SplashStyle.embracePositivity, shouldPauseView: true),
    },
    'Splash (We\'re Done Hiding)': {
      'route': SplashRoute(style: SplashStyle.weAreDoneHiding, shouldPauseView: true),
    },
    'Splash (Your Condition Your Terms)': {
      'route': SplashRoute(style: SplashStyle.yourConditionYourTerms, shouldPauseView: true),
    },
    'Splash (Lets Keep it Real)': {
      'route': SplashRoute(style: SplashStyle.letsKeepItReal, shouldPauseView: true),
    },
    'Splash (Tomorrow Starts Now)': {
      'route': SplashRoute(style: SplashStyle.tomorrowStartsNow, shouldPauseView: true),
    },
  },
  'Onboarding': {
    'Onboarding (Welcome)': {
      'route': OnboardingRoute(stepIndex: 0),
      'before': [PreloadOnboardingStepsAction()],
    },
    'Onboarding (Feature)': {
      'route': OnboardingRoute(stepIndex: 1),
      'before': [PreloadOnboardingStepsAction()],
    },
    'Onboarding (Our Pledge)': {
      'route': OnboardingRoute(stepIndex: 4),
      'before': [PreloadOnboardingStepsAction()],
    },
    'Onboarding (Your Pledge)': {
      'route': OnboardingRoute(stepIndex: 5),
      'before': [PreloadOnboardingStepsAction()],
    },
  },
  'Registration': {
    'Create Account': {
      'route': const CreateAccountRoute(),
    },
  },
  'Design System (Atoms)': {
    'Buttons': {
      'route': PPOButtonTestRoute(),
    },
    'Checkboxes': {
      'route': PPOCheckboxTestRoute(),
    },
    'Glass Container': {
      'route': PPOGlassContainerTestRoute(),
    },
    'Typography': {
      'route': const PPOTypographyTestRoute(),
    },
    'Stamps': {
      'route': PPOStampTestRoute(),
    },
    'Page Indicators': {
      'route': PPORouteIndicatorTestRoute(),
    },
  },
  'Design System (Templates)': {
    'Scaffolds Decorations': {
      'route': const PPOScaffoldDecorationTestRoute(),
    },
  },
};
