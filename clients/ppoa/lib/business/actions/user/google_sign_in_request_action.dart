// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

class GoogleSignInRequestAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Sign in with Google';

  @override
  String get simulationDescription => 'Uses Firebase to attempt to sign in with Google as the sign in provider';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    log.fine('Attempting to sign in with Google');
    await super.action(notifier, params);

    final bool hasFirebaseAuth = locator.isRegistered<FirebaseAuth>();
    final bool hasGoogleSignIn = locator.isRegistered<GoogleSignIn>();

    if (!hasFirebaseAuth || !hasGoogleSignIn) {
      log.severe('Cannot sign in with Google as missing registrations');
      return;
    }

    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) {
      log.info('Missing account, likely flow was cancelled');
      return;
    }
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }
}
