import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';

class SplashLifecycle with ServiceMixin, LifecycleMixin {
  @override
  void onFirstRender() {
    bootstrapApplication();
    super.onFirstRender();
  }

  Future<void> bootstrapApplication() async {
    log.fine('Attempting to bootstrap application');
    await features.preloadOnboardingFeatures();
  }
}
