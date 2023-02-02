// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

class UpdateCurrentExceptionAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Toggle exception';

  @override
  String get simulationDescription => 'Displays a random exception to be displayed to the user';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.button;

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    if (params.isEmpty) {
      log.v('No exception found, removing from UI');
      stateNotifier.state = stateNotifier.state.copyWith(
        systemState: stateNotifier.state.systemState.copyWith(
          currentException: null,
        ),
      );
    } else {
      final Object? exception = params.first;
      log.v('Found new exception: $exception');
      log.v(StackTrace.current);

      stateNotifier.state = stateNotifier.state.copyWith(
        systemState: stateNotifier.state.systemState.copyWith(
          currentException: exception,
        ),
      );
    }
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }
}
