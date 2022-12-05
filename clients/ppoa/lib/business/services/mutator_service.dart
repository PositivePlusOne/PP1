// Project imports:
import 'package:ppoa/business/actions/system/system_busy_toggle_action.dart';
import 'package:ppoa/business/actions/user/google_sign_in_request_action.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import '../actions/onboarding/preload_onboarding_steps_action.dart';
import '../state/mutators/base_mutator.dart';

final Iterable<BaseMutator> environmentMutators = <BaseMutator>[
  PreloadOnboardingStepsAction(),
];

final Iterable<BaseMutator> systemMutators = <BaseMutator>[
  SystemBusyToggleAction(),
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
  }) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.action(stateNotifier, params);
  }

  Future<void> performSimulatedAction<T extends BaseMutator>({
    List<dynamic> params = const <dynamic>[],
  }) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform simulated action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.simulateAction(stateNotifier, params);
  }
}
