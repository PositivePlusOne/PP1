// Dart imports:
import 'dart:async';

// Project imports:
import 'package:ppoa/business/hooks/lifecycle_hook.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/extensions/shared_preference_extensions.dart';
import '../../business/actions/onboarding/preload_onboarding_steps_action.dart';
import '../../business/actions/system/update_app_check_token_action.dart';
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
        return const Duration(seconds: 3);
      default:
        return const Duration(seconds: 2);
    }
  }

  @override
  void onFirstRender() {
    prepareTimer();
    super.onFirstRender();
  }

  void prepareTimer() {
    if (shouldPauseView) {
      log.v('Skipping timer callback on Splash page');
      return;
    }

    log.v('Preparing a new splash callback timer');
    timer = Timer(timerDuration, onTimerExecuted);
  }

  Future<void> onTimerExecuted() async {
    log.v('Splash callback executed');
    timer?.cancel();

    switch (style) {
      case SplashStyle.tomorrowStartsNow:
        bootstrapApplication();
        break;
      default:
        log.v('Navigating to next splash index');
        final int newIndex = SplashStyle.values.indexOf(style) + 1;
        await router.push(SplashRoute(style: SplashStyle.values[newIndex]));
        break;
    }
  }

  Future<void> bootstrapApplication() async {
    log.v('Attempting to bootstrap application');
    await mutator.performAction<PreloadOnboardingStepsAction>();
    await mutator.performAction<UpdateAppCheckTokenAction>();
    // await mutator.performAction<PreloadUserDataAction>();

    final bool hasViewedPledges = await sharedPreferences.hasViewedPledges();

    if (hasViewedPledges) {
      await router.replaceAll([const HomeRoute()]);
    } else {
      await router.replaceAll([OnboardingRoute(stepIndex: 0)]);
    }
  }
}
