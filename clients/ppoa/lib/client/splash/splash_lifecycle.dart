// Project imports:
import 'package:ppoa/business/actions/onboarding/preload_onboarding_features_action.dart';
import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import '../../business/actions/onboarding/preload_onboarding_steps_action.dart';

class SplashLifecycle with ServiceMixin, LifecycleMixin {
  @override
  void onFirstRender() {
    bootstrapApplication();
    super.onFirstRender();
  }

  Future<void> bootstrapApplication() async {
    log.fine('Attempting to bootstrap application');
    await mutator.performAction<PreloadOnboardingFeaturesAction>();
    await mutator.performAction<PreloadOnboardingStepsAction>();

    await router.push(OnboardingRoute(stepIndex: 2));
  }
}
