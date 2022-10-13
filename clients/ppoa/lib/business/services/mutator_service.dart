import 'package:ppoa/business/services/service_mixin.dart';

import '../state/app_state.dart';
import '../state/design_system/mutators/update_primary_colour_mutator.dart';
import '../state/mutators/base_mutator.dart';

final Iterable<BaseMutator> mutators = <BaseMutator>[
  UpdatePrimaryColourMutator(),
];

class MutatorService with ServiceMixin {
  Future<void> performAction<T extends BaseMutator>(AppStateNotifier notifier, List<dynamic> params) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.action(notifier, params);
  }

  Future<void> performSimulatedAction<T extends BaseMutator>(AppStateNotifier notifier, List<dynamic> params) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform simulated action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.simulateAction(notifier, params);
  }
}
