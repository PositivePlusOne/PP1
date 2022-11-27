// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:ppoa/business/actions/onboarding/preload_onboarding_steps_action.dart';
import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/design_system/models/design_system_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/system/system_state.dart';
import 'package:ppoa/business/state/user/models/user.dart';
import '../../helpers/app_state_helpers.dart';

void main() {
  test('Can preload steps when no locale is provided and features are present', testPreloadStepsNoLocaleFeatures);
  test('Can preload steps when locale is provided and features are present', testPreloadStepsLocaleFeatures);
}

Future<void> testPreloadStepsLocaleFeatures() async {
  final AppState initialState = AppState(
    systemState: SystemState.empty(),
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

  await mutatorService.performAction<PreloadOnboardingStepsAction>(params: <dynamic>[
    const Locale('es', ''),
  ]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 3);
}

Future<void> testPreloadStepsNoLocaleFeatures() async {
  final AppState initialState = AppState(
    systemState: SystemState.empty(),
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

  await mutatorService.performAction<PreloadOnboardingStepsAction>();

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 4);
}
