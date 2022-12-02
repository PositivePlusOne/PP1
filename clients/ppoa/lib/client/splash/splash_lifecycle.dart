// Project imports:
import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/extensions/shared_preference_extensions.dart';
import '../../business/actions/onboarding/preload_onboarding_steps_action.dart';
import '../routing/app_router.gr.dart';

enum SplashStyle {
  embracePositivity,
  weAreDoneHiding,
  yourConditionYourTerms,
  letsKeepItReal,
  tomorrowStartsNow,
}

class SplashLifecycle with ServiceMixin, LifecycleMixin {
  Future<void> bootstrapApplication() async {
    log.fine('Attempting to bootstrap application');
    await mutator.performAction<PreloadOnboardingStepsAction>();

    final bool hasViewedPledges = await preferences.hasViewedPledges();

    if (hasViewedPledges) {
      await router.push(const CreateAccountRoute());
    } else {
      await router.push(OnboardingRoute(stepIndex: 0));
    }
  }
}
