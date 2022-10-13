// ignore_for_file: invalid_use_of_protected_member

// Project imports:
import 'package:ppoa/business/helpers/validators.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../app_state.dart';

class UpdatePrimaryColourMutator extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Update primary colour';

  @override
  String get simulationDescription => 'Changes the brand primary colour throughout the application';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.text;

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    if (params.isEmpty || params.first is! String) {
      log.warning('Cannot perform action (UpdatePrimaryColourMutator), wrong parameter types');
      return;
    }

    final String colour = params.first;
    if (!isHexColor(colour)) {
      log.warning('Invalid hex colour supplied to mutator (UpdatePrimaryColourMutator): $colour');
      return;
    }

    //* Mutate
    notifier.state.copyWith(
      designSystem: notifier.state.designSystem.copyWith(
        brand: notifier.state.designSystem.brand.copyWith(
          primaryColor: colour,
        ),
      ),
    );

    await super.action(notifier, params);
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    if (params.isEmpty || params.first is! String) {
      log.warning('Cannot perform simulated action (UpdatePrimaryColourMutator), wrong parameter types');
      return;
    }

    final String colour = params.first;
    await action(notifier, <dynamic>[colour]);
  }
}
