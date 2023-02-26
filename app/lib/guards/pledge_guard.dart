// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/user/pledge_controller.dart';

class PledgeGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AsyncPledgeController pledgeProvider = providerContainer.read(asyncPledgeControllerProvider.notifier);

    if (!pledgeProvider.state.hasValue) {
      resolver.next(false);
      return;
    }

    final bool hasAcceptedPledges = pledgeProvider.state.value!.arePledgesAccepted;
    if (hasAcceptedPledges) {
      resolver.next(true);
      return;
    }

    router.removeWhere((route) => true);
    router.push(const OnboardingWelcomeRoute());
    resolver.next(false);
  }
}
