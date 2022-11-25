// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../../client/constants/ppo_localizations.dart';
import '../../constants/onboarding_domain_constants.dart';

class PreloadOnboardingStepsAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Preload onboarding steps';

  @override
  String get simulationDescription => 'Loads a set of steps to display to the user when first loading the application.';

  @override
  Future<void> action(AppStateNotifier notifier, List<dynamic> params) async {
    log.finer('Attempting to preload onboarding steps');
    final AppState appState = notifier.state;
    final List<OnboardingStep> steps = <OnboardingStep>[];

    Locale expectedLocale = kDefaultLocale;
    if (params.any((element) => element is Locale)) {
      expectedLocale = params.firstWhere((element) => element is Locale);
    }

    final String languageCode = expectedLocale.languageCode;

    //* Check welcome state
    final bool hasSeenWelcomeView = preferences.getBool(kWelcomeStepViewedKey) ?? false;
    if (!hasSeenWelcomeView) {
      steps.add(const OnboardingStep(type: OnboardingStepType.welcome, key: kWelcomeStepViewedKey, markdown: ''));
    }

    //* Check features state
    for (final OnboardingFeature feature in appState.environment.onboardingFeatures) {
      final String featureKey = '${kStepViewedKeyPrefix}_${feature.key}';
      if (feature.locale != languageCode) {
        continue;
      }

      final bool hasSeenFeatureView = preferences.getBool(featureKey) ?? false;
      if (!hasSeenFeatureView) {
        steps.add(OnboardingStep(type: OnboardingStepType.feature, key: featureKey, markdown: feature.localizedMarkdown));
      }
    }

    //* Check pledge state
    final bool hasSeenOurPledgeView = preferences.getBool(kOurPledgeStepViewedKey) ?? false;
    if (!hasSeenOurPledgeView) {
      steps.add(const OnboardingStep(type: OnboardingStepType.ourPledge, key: kOurPledgeStepViewedKey, markdown: ''));
    }

    final bool hasSeenYourPledgeView = preferences.getBool(kYourPledgeStepViewedKey) ?? false;
    if (!hasSeenYourPledgeView) {
      steps.add(const OnboardingStep(type: OnboardingStepType.yourPledge, key: kYourPledgeStepViewedKey, markdown: ''));
    }

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
