// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/actions/system/system_busy_toggle_action.dart';
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../helpers/app_state_helpers.dart';

void main() {
  testZephyr('', 'Can toggle busy state when no parameters are passed', testToggleBusyStateNoParams);
  testZephyr('', 'Can toggle busy state when parameters are passed', testToggleBusyStateParams);
}

Future<void> testToggleBusyStateParams(String testCase) async {
  AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);
  initialState = initialState.copyWith(
    systemState: initialState.systemState.copyWith(
      isBusy: false,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<SystemBusyToggleAction>(params: <dynamic>[
    false,
  ]);

  final AppState mutatedState = notifier.state;
  expect(mutatedState.systemState.isBusy, isFalse);
}

Future<void> testToggleBusyStateNoParams(String testCaseName) async {
  AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);
  initialState = initialState.copyWith(
    systemState: initialState.systemState.copyWith(
      isBusy: false,
    ),
  );

  await setTestServiceState(initialState);

  final MutatorService mutatorService = GetIt.instance.get();
  final AppStateNotifier notifier = GetIt.instance.get();

  await mutatorService.performAction<SystemBusyToggleAction>();

  final AppState mutatedState = notifier.state;
  expect(mutatedState.systemState.isBusy, isTrue);
}
