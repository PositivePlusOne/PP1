import 'package:auto_route/auto_route.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';

import '../../../business/state/app_state.dart';

class AuthenticationGuard extends AutoRouteGuard with ServiceMixin {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AppState appState = stateNotifier.state;
    final bool isAuthenticated = appState.user.id.isNotEmpty;
    if (isAuthenticated) {
      resolver.next(true);
      return;
    }

    final bool hasSteps = appState.environment.onboardingSteps.isNotEmpty;
    if (hasSteps) {
      router.push(const OnboardingRoute());
    } else {
      router.push(const SplashRoute());
    }
  }
}
