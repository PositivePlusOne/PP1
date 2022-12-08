// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/actions/system/update_current_exception_action.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../helpers/app_state_helpers.dart';

void main() {
  testZephyr('', 'Can remove exception no parameters are passed', testRemoveException);
  testZephyr('', 'Can add exception when parameters are passed', testAddException);
}

Future<void> testAddException(String testCase) async {
  AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);
  initialState = initialState.copyWith(
    systemState: initialState.systemState.copyWith(
      isBusy: false,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<UpdateCurrentExceptionAction>(params: <dynamic>[
    'mock',
  ]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.systemState.currentException, 'mock');
}

Future<void> testRemoveException(String testCaseName) async {
  AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);
  initialState = initialState.copyWith(
    systemState: initialState.systemState.copyWith(
      isBusy: false,
      currentException: 'mock',
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<UpdateCurrentExceptionAction>();

  final AppState mutatedState = notifier.state;
  expect(mutatedState.systemState.currentException, isNull);
}
