import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';

class OnboardingLifecycle with ServiceMixin, LifecycleMixin {
  @override
  void beforeFirstRender() {
    preloadOnboardingSteps();
    super.beforeFirstRender();
  }

  // Using the preferences plugins, will load pages representing each onboarding step
  Future<void> preloadOnboardingSteps() async {}
}
