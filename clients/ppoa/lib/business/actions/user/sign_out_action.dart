// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../../client/routing/app_router.gr.dart';

class SignOutAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Sign out';

  @override
  String get simulationDescription => 'Signs the user out, and returns to the splash view';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.button;

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await router.replaceAll([SplashRoute()]);
  }

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await router.replaceAll([SplashRoute()]);
  }
}
