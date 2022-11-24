import 'package:ppoa/client/routing/app_router.gr.dart';

final Map<String, dynamic> kSimulationRoutes = <String, dynamic>{
  'Splash and Onboarding': {
    OnboardingRoute(stepIndex: 0): {
      'name': 'Onboarding (Welcome)',
    },
  },
  'Design System (Atoms)': {
    PPOButtonTestRoute(): {
      'name': 'Buttons',
    },
    PPOCheckboxTestRoute(): {
      'name': 'Checkboxes',
    },
    PPOGlassContainerTestRoute(): {
      'name': 'Glass Container',
    },
    const PPOTypographyTestRoute(): {
      'name': 'Typography',
    },
    PPOStampTestRoute(): {
      'name': 'Stamps',
    },
    PPORouteIndicatorTestRoute(): {
      'name': 'Page Indicators',
    },
  },
  'Design System (Templates)': {
    const PPOScaffoldDecorationTestRoute(): {
      'name': 'Scaffolds Decorations',
    },
  },
};
