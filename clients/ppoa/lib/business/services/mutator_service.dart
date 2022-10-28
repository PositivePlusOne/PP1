import 'package:ppoa/business/services/service_mixin.dart';

import '../state/design_system/mutators/update_primary_colour_mutator.dart';
import '../state/mutators/base_mutator.dart';

final Iterable<BaseMutator> designSystemMutators = <BaseMutator>[
  UpdatePrimaryColourMutator(),
];

final Iterable<BaseMutator> mutators = <BaseMutator>[
  ...designSystemMutators,
];

class MutatorService with ServiceMixin {
  Future<void> performAction<T extends BaseMutator>(List<dynamic> params) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.action(stateNotifier, params);
  }

  Future<void> performSimulatedAction<T extends BaseMutator>(List<dynamic> params) async {
    if (!mutators.any((element) => element is T)) {
      log.severe('Cannot perform simulated action $T, missing mutator registration');
      return;
    }

    final BaseMutator mutator = mutators.firstWhere((element) => element is T);
    await mutator.simulateAction(stateNotifier, params);
  }
}
