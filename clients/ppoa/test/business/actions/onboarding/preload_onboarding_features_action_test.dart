import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppoa/business/actions/onboarding/preload_onboarding_features_action.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';

import '../../helpers/app_state_helpers.dart';

void main() {
  test('Can preload onboarding features into application state', testPreloadApplicationFeatures);
}

Future<void> testPreloadApplicationFeatures() async {
  final AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);
  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<PreloadOnboardingFeaturesAction>([]);
  final AppState mutatedAppState = notifier.state;

  expect(mutatedAppState.environment.onboardingFeatures, isNotEmpty);
}
