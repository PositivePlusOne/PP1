// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox_test_view.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container_test_view.dart';
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import '../components/atoms/buttons/ppo_button_test_view.dart';
import '../components/atoms/stamps/ppo_stamps_test_view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true, meta: $AppRouter.kSimulatorGroupOther),
    AutoRoute(page: HomePage, path: '/home', meta: $AppRouter.kSimulatorGroupOther),

    //* Bespoke Simulation Routes
    AutoRoute(page: PPOButtonTestView, path: '/design-system/buttons', meta: $AppRouter.kSimulatorGroupDesignSystem),
    AutoRoute(page: PPOCheckboxTestView, path: '/design-system/checkboxes', meta: $AppRouter.kSimulatorGroupDesignSystem),
    AutoRoute(page: PPOGlassContainerTestView, path: '/design-system/glass-container', meta: $AppRouter.kSimulatorGroupDesignSystem),
    AutoRoute(page: PPOStampTestView, path: '/design-system/stamps', meta: $AppRouter.kSimulatorGroupDesignSystem),
  ],
)
class $AppRouter {
  static const String kGroupKey = 'Simulator Group';

  static const Map<String, dynamic> kSimulatorGroupOther = {kGroupKey: 'Other'};
  static const Map<String, dynamic> kSimulatorGroupDesignSystem = {kGroupKey: 'Design System'};
}
