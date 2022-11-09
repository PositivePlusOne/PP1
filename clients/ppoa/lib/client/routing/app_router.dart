// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox_test_view.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container_test_view.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator_test_view.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold_test_view.dart';
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import '../components/atoms/buttons/ppo_button_test_view.dart';
import '../components/atoms/stamps/ppo_stamps_test_view.dart';
import '../simulation/views/ppo_typography_test_view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true, meta: $AppRouter.kSimulatorGroupOther),
    AutoRoute(page: HomePage, path: '/home', meta: $AppRouter.kSimulatorGroupOther),

    //* Design System Routes (Atom)
    AutoRoute(page: PPOButtonTestView, path: '/design-system/buttons', meta: $AppRouter.kSimulatorGroupDesignSystemAtoms),
    AutoRoute(page: PPOCheckboxTestView, path: '/design-system/checkboxes', meta: $AppRouter.kSimulatorGroupDesignSystemAtoms),
    AutoRoute(page: PPOGlassContainerTestView, path: '/design-system/glass-container', meta: $AppRouter.kSimulatorGroupDesignSystemAtoms),
    AutoRoute(page: PPOTypographyTestView, path: '/design-system/typography', meta: $AppRouter.kSimulatorGroupDesignSystemAtoms),
    AutoRoute(page: PPOStampTestView, path: '/design-system/stamps', meta: $AppRouter.kSimulatorGroupDesignSystemAtoms),

    //* Design System Routes (Templates)
    AutoRoute(page: PPOScaffoldTestView, path: '/design-system/scaffold', meta: $AppRouter.kSimulatorGroupDesignSystemTemplates),
    AutoRoute(page: PPOPageIndicatorTestView, path: '/design-system/page-indicator', meta: $AppRouter.kSimulatorGroupDesignSystem),
  ],
)
class $AppRouter {
  static const String kGroupKey = 'Simulator Group';

  static const Map<String, dynamic> kSimulatorGroupOther = {kGroupKey: 'Other'};
  static const Map<String, dynamic> kSimulatorGroupDesignSystemAtoms = {kGroupKey: 'Design System (Atoms)'};
  static const Map<String, dynamic> kSimulatorGroupDesignSystemTemplates = {kGroupKey: 'Design System (Templates)'};
}
