import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppoa/business/actions/onboarding/preload_onboarding_steps_action.dart';
import 'package:ppoa/business/constants/onboarding_domain_constants.dart';
import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/design_system/models/design_system_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/user/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/app_state_helpers.dart';

void main() {
  test('Can preload steps when no locale is provided and features are present', testPreloadStepsNoLocaleFeatures);
  test('Can preload steps when locale is provided and features are present', testPreloadStepsLocaleFeatures);
  test('Can preload steps when already viewed welcome and pledge views', testPreloadStepsLocaleFeaturesViewed);
}

Future<void> testPreloadStepsLocaleFeaturesViewed() async {
  final AppState initialState = AppState(
    designSystem: DesignSystemState.empty(),
    user: User.empty(),
    environment: const Environment(
      onboardingFeatures: <OnboardingFeature>[
        OnboardingFeature(key: 'mock_one', locale: 'en', localizedMarkdown: ''),
      ],
      onboardingSteps: <OnboardingStep>[],
      type: EnvironmentType.test,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();
  final SharedPreferences sharedPreferences = GetIt.instance.get();

  await sharedPreferences.setBool(kWelcomeStepViewedKey, true);
  await sharedPreferences.setBool(kPledgeStepViewedKey, true);
  await mutatorService.performAction<PreloadOnboardingStepsAction>(<dynamic>[]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 1);
  expect(mutatedState.environment.onboardingSteps[0].key, 'viewed_mock_one');
}

Future<void> testPreloadStepsLocaleFeatures() async {
  final AppState initialState = AppState(
    designSystem: DesignSystemState.empty(),
    user: User.empty(),
    environment: const Environment(
      onboardingFeatures: <OnboardingFeature>[
        OnboardingFeature(key: 'mock_one', locale: 'en', localizedMarkdown: ''),
      ],
      onboardingSteps: <OnboardingStep>[],
      type: EnvironmentType.test,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<PreloadOnboardingStepsAction>(<dynamic>[
    const Locale('es', ''),
  ]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 2);
  expect(mutatedState.environment.onboardingSteps[0].key, kWelcomeStepViewedKey);
  expect(mutatedState.environment.onboardingSteps[1].key, kPledgeStepViewedKey);
}

Future<void> testPreloadStepsNoLocaleFeatures() async {
  final AppState initialState = AppState(
    designSystem: DesignSystemState.empty(),
    user: User.empty(),
    environment: const Environment(
      onboardingFeatures: <OnboardingFeature>[
        OnboardingFeature(key: 'mock_one', locale: 'en', localizedMarkdown: ''),
      ],
      onboardingSteps: <OnboardingStep>[],
      type: EnvironmentType.test,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<PreloadOnboardingStepsAction>(<dynamic>[]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 3);
  expect(mutatedState.environment.onboardingSteps[0].key, kWelcomeStepViewedKey);
  expect(mutatedState.environment.onboardingSteps[1].key, 'viewed_mock_one');
  expect(mutatedState.environment.onboardingSteps[2].key, kPledgeStepViewedKey);
}
