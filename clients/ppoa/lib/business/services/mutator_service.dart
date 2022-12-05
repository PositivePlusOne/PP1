// Project imports:
import 'package:ppoa/business/actions/system/system_busy_toggle_action.dart';
import 'package:ppoa/business/actions/system/update_current_exception_action.dart';
import 'package:ppoa/business/actions/user/google_sign_in_request_action.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import '../actions/onboarding/preload_onboarding_steps_action.dart';
import '../state/mutators/base_mutator.dart';

final Iterable<BaseMutator> environmentMutators = <BaseMutator>[
  PreloadOnboardingStepsAction(),
];

final Iterable<BaseMutator> systemMutators = <BaseMutator>[
  SystemBusyToggleAction(),
  UpdateCurrentExceptionAction(),
];

final Iterable<BaseMutator> designSystemMutators = <BaseMutator>[];

final Iterable<BaseMutator> userMutators = <BaseMutator>[
  GoogleSignInRequestAction(),
];

final Iterable<BaseMutator> mutators = <BaseMutator>[
  ...environmentMutators,
  ...systemMutators,
  ...designSystemMutators,
  ...userMutators,
];

class MutatorService with ServiceMixin {
  Future<void> performAction<T extends BaseMutator>({
    List<dynamic> params = const <dynamic>[],
    bool markAsBusy = false,
  }) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);

    try {
      if (markAsBusy) {
        await performAction<SystemBusyToggleAction>(params: [true]);
      }

      await mutator.action(stateNotifier, params);
    } catch (ex) {
      await performAction<UpdateCurrentExceptionAction>(params: [ex]);
    } finally {
      if (markAsBusy) {
        await performAction<SystemBusyToggleAction>(params: [false]);
      }
    }
  }

  Future<void> performSimulatedAction<T extends BaseMutator>({
    List<dynamic> params = const <dynamic>[],
    bool markAsBusy = false,
  }) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform simulated action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);

    try {
      if (markAsBusy) {
        await performAction<SystemBusyToggleAction>(params: [true]);
      }

      await mutator.simulateAction(stateNotifier, params);
    } catch (ex) {
      await performAction<UpdateCurrentExceptionAction>(params: [ex]);
    } finally {
      if (markAsBusy) {
        await performAction<SystemBusyToggleAction>(params: [false]);
      }
    }
  }
}
