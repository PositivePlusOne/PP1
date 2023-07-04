// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/system_controller.dart';
import '../main.dart';

class DevelopmentGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (router.current.name == DevelopmentRoute.name) {
      resolver.next(false);
      return;
    }

    final SystemControllerState systemControllerState = providerContainer.read(systemControllerProvider);
    final bool canNavigate = systemControllerState.environment != SystemEnvironment.production;
    resolver.next(canNavigate);
  }
}
