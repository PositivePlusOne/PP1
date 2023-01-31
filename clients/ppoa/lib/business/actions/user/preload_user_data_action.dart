// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../services/service_mixin.dart';

class PreloadUserDataAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => throw UnimplementedError();

  @override
  String get simulationDescription => throw UnimplementedError();

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    log.info('Attempting to preload user data');
    if (!locator.isRegistered<FirebaseAuth>() || !locator.isRegistered<FirebaseFirestore>()) {
      log.severe('Failed to find authenticator in services');
      return;
    }

    //* We use authStateChanges over currentUser as this will delay startup
    final User? user = await firebaseAuth.authStateChanges().first;
    if (user == null) {
      log.fine('Not logged in, cannot preload user');
      return;
    }

    final String uid = user.uid;
    final DocumentSnapshot publicSnapshot = await firebaseFirestore.collection('public_users').doc(uid).get();
    final DocumentSnapshot privateSnapshot = await firebaseFirestore.collection('private_users').doc(uid).get();
    final DocumentSnapshot systemSnapshot = await firebaseFirestore.collection('system_users').doc(uid).get();

    log.info('Found user data');
    stateNotifier.state = stateNotifier.state.copyWith(
      user: stateNotifier.state.user.copyWith(
        publicData: publicSnapshot.data() as Map<String, dynamic>,
        privateData: privateSnapshot.data() as Map<String, dynamic>,
        systemData: systemSnapshot.data() as Map<String, dynamic>,
      ),
    );

    return super.action(notifier, params);
  }
}
