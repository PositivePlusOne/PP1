// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import '../splash/splash_connector.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashConnector, initial: true),
  ],
)
class $AppRouter {}
