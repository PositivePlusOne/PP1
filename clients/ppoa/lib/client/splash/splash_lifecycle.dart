// Project imports:
import 'dart:async';

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
  Timer? timer;

  SplashStyle style = SplashStyle.embracePositivity;
  bool shouldPauseView = false;

  Duration get timerDuration {
    switch (style) {
      case SplashStyle.tomorrowStartsNow:
        return const Duration(seconds: 2);
      default:
        return const Duration(seconds: 1);
    }
  }

  @override
  void onFirstRender() {
    prepareTimer();
    super.onFirstRender();
  }

  void prepareTimer() {
    if (shouldPauseView) {
      log.finer('Skipping timer callback on Splash page');
      return;
    }

    log.finer('Preparing a new splash callback timer');
    timer = Timer(timerDuration, onTimerExecuted);
  }

  void onTimerExecuted() {
    log.fine('Splash callback executed');
    timer?.cancel();

    switch (style) {
      case SplashStyle.tomorrowStartsNow:
        bootstrapApplication();
        break;
      default:
        log.fine('Navigating to next splash index');
        router.push(SplashRoute(style: SplashStyle.values[SplashStyle.values.indexOf(style) + 1]));
        break;
    }
  }

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
