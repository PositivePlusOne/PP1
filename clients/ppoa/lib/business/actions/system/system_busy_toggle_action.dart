// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

class SystemBusyToggleAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Toggle busy state';

  @override
  String get simulationDescription => 'Toggles the busy state of the application.';

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    log.v('Toggling busy state of the application');
    bool newBusyState = !notifier.state.systemState.isBusy;
    if (params.any((element) => element is bool)) {
      newBusyState = params.firstWhere((element) => element is bool);
    }

    notifier.state = notifier.state.copyWith(
      systemState: notifier.state.systemState.copyWith(
        isBusy: newBusyState,
      ),
    );

    await super.action(notifier, params);
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.button;
}
