// Project imports:
import 'package:ppoa/client/routing/app_router.gr.dart';

final Map<String, dynamic> kSimulationRoutes = <String, dynamic>{
  'Splash and Onboarding': {
    'Onboarding (Welcome)': {
      'route': OnboardingRoute(stepIndex: 0),
    },
    'Onboarding (Feature)': {
      'route': OnboardingRoute(stepIndex: 1),
    },
    'Onboarding (Our Pledge)': {
      'route': OnboardingRoute(stepIndex: 4),
    },
    'Onboarding (Your Pledge)': {
      'route': OnboardingRoute(stepIndex: 5),
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
