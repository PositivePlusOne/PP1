// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';
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
      router.push(OnboardingRoute(stepIndex: 0));
    } else {
      router.push(SplashRoute(style: SplashStyle.values.first));
    }
  }
}
