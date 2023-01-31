// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/actions/onboarding/preload_onboarding_steps_action.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import '../../../client/helpers/app_state_builder.dart';
import '../../../client/helpers/widget_tester_helpers.dart';

void main() {
  testZephyrWidgets('', 'Can preload onboarding steps if features are present', testPreloadStepsLocaleFeatures);
}

Future<void> testPreloadStepsLocaleFeatures(WidgetTester tester, String testCaseName) async {
  final AppStateBuilder appStateBuilder = AppStateBuilder.create();
  final AppState initialState = appStateBuilder.appState;

  await pumpWidgetWithProviderScopeAndServices(const Scaffold(), initialState, tester);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<PreloadOnboardingStepsAction>();

  final AppState mutatedState = notifier.state;
  expect(mutatedState.environment.onboardingSteps.length, 6);
}
