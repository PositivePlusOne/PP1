// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

class PreloadOnboardingStepsAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Preload onboarding steps';

  @override
  String get simulationDescription => 'Loads a set of steps to display to the user when first loading the application.';

  @override
  Future<void> action(AppStateNotifier notifier, List<dynamic> params) async {
    log.finer('Attempting to preload onboarding steps');
    final List<OnboardingStep> steps = <OnboardingStep>[];

    if (router.navigatorKey.currentState == null) {
      log.severe('Failed to preload steps, cannot get context');
    }

    final BuildContext context = router.navigatorKey.currentState!.context;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    //* Add welcome state
    steps.add(const OnboardingStep(type: OnboardingStepType.welcome));

    //* Add features state
    steps.addAll(<OnboardingStep>[
      const OnboardingStep(type: OnboardingStepType.feature, title: localizations.onboarding_connections_title, body: localizations.onboarding_connections_body),
      const OnboardingStep(type: OnboardingStepType.feature, title: localizations.onboarding_education_title, body: localizations.onboarding_education_body),
      const OnboardingStep(type: OnboardingStepType.feature, title: localizations.onboarding_guidance_title, body: localizations.onboarding_guidance_body),
    ]);

    //* Add pledge state
    steps.add(const OnboardingStep(type: OnboardingStepType.ourPledge));
    steps.add(const OnboardingStep(type: OnboardingStepType.yourPledge));

    notifier.state = notifier.state.copyWith(
      environment: notifier.state.environment.copyWith(
        onboardingSteps: steps,
      ),
    );

    await super.action(notifier, params);
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    throw UnimplementedError();
  }

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;
}
