// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import 'package:ppoa/simulation/components/design_system_buttons_view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: HomePage, path: '/home'),

    //* Bespoke Simulation Routes
    AutoRoute(page: DesignSystemButtonsView, path: '/design-system/buttons'),
  ],
)
class $AppRouter {}
