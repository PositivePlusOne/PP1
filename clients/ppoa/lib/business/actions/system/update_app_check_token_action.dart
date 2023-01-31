// Package imports:
import 'package:firebase_app_check/firebase_app_check.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../services/service_mixin.dart';

class UpdateAppCheckTokenAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Update app check token';

  @override
  String get simulationDescription => 'Loads the app check token for the user, if present.';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    log.i('Attempting to cache app check token');
    final bool isAppCheckRegistered = locator.isRegistered<FirebaseAppCheck>();
    if (!isAppCheckRegistered) {
      log.i('Missing app check service');
      return;
    }

    final String? token = await firebaseAppCheck.getToken();
    if (token == null) {
      log.i('Missing app check token');
      return;
    }

    log.d('Got app check token: $token');
    stateNotifier.state = stateNotifier.state.copyWith(
      systemState: stateNotifier.state.systemState.copyWith(
        appCheckToken: token,
      ),
    );
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {}
}
