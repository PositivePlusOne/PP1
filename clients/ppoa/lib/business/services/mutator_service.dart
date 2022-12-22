// Project imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:ppoa/business/actions/system/system_busy_toggle_action.dart';
import 'package:ppoa/business/actions/system/update_current_exception_action.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import '../state/mutators/base_mutator.dart';
import 'actions.dart';

class MutatorService with ServiceMixin {
  Future<void> performAction<T extends BaseMutator>({
    List<dynamic> params = const <dynamic>[],
    bool markAsBusy = false,
    bool removeCurrentException = true,
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

      if (removeCurrentException) {
        await performAction<UpdateCurrentExceptionAction>(params: [], removeCurrentException: false);
      }

      await mutator.action(stateNotifier, params);
    } catch (ex) {
      log.severe('Failed action with exception: $ex');
      if (locator.isRegistered<FirebaseCrashlytics>()) {
        await firebaseCrashlytics.recordError(ex, StackTrace.current);
      }

      await performAction<UpdateCurrentExceptionAction>(params: [ex], removeCurrentException: false);
    } finally {
      if (markAsBusy) {
        await performAction<SystemBusyToggleAction>(params: [false]);
      }
    }
  }

  Future<void> performSimulatedAction<T extends BaseMutator>({
    List<dynamic> params = const <dynamic>[],
    bool markAsBusy = false,
    bool removeCurrentException = true,
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

      if (removeCurrentException) {
        await performAction<UpdateCurrentExceptionAction>(params: []);
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
