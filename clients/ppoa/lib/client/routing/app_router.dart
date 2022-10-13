// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/simulation/views/design_system_buttons_view.dart';
import 'package:ppoa/client/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true, meta: $AppRouter.kSimulatorGroupOther),
    AutoRoute(page: HomePage, path: '/home', meta: $AppRouter.kSimulatorGroupOther),

    //* Bespoke Simulation Routes
    AutoRoute(page: DesignSystemButtonsView, path: '/design-system/buttons', meta: $AppRouter.kSimulatorGroupDesignSystem),
  ],
)
class $AppRouter {
  static const String kGroupKey = 'Simulator Group';

  static const Map<String, dynamic> kSimulatorGroupOther = {kGroupKey: 'Other'};
  static const Map<String, dynamic> kSimulatorGroupDesignSystem = {kGroupKey: 'Design System'};
}
