// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:ppoa/business/constants/function_constants.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../constants/database_constants.dart';

class FirebaseCreateAccountAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Create account';

  @override
  String get simulationDescription => 'Calls a backend function to create the users account if they are logged in.';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) {
    throw UnimplementedError();
  }

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    log.fine('Attempting to create profile');
    final bool isFirebaseFunctionsRegistered = locator.isRegistered<FirebaseFunctions>();
    final bool isFirebaseAuthRegistered = locator.isRegistered<FirebaseAuth>();
    final bool isFirebaseFirestoreRegistered = locator.isRegistered<FirebaseFirestore>();

    if (!isFirebaseFunctionsRegistered || !isFirebaseAuthRegistered || !isFirebaseFirestoreRegistered) {
      log.severe('Cannot create account, missing registration');
      return;
    }

    if (firebaseAuth.currentUser == null) {
      log.severe('Cannot create account, not logged in.');
      return;
    }
    try {
      final HttpsCallable callable = firebaseFunctions.httpsCallable(kFunctionCreateAccount);
      await callable.call();
    } catch (_) {
      log.severe('Failed to create account, signing out');
      await firebaseAuth.signOut();
      rethrow;
    }

    final DocumentSnapshot<Map<String, dynamic>> publicSnapshot = await firebaseFirestore.collection(kCollectionNamePublicProfiles).doc(firebaseAuth.currentUser!.uid).get();
    final DocumentSnapshot<Map<String, dynamic>> privateSnapshot = await firebaseFirestore.collection(kCollectionNamePrivateProfiles).doc(firebaseAuth.currentUser!.uid).get();
    final DocumentSnapshot<Map<String, dynamic>> systemSnapshot = await firebaseFirestore.collection(kCollectionNameSystemProfiles).doc(firebaseAuth.currentUser!.uid).get();

    final bool hasCreatedProfile = publicSnapshot.exists && privateSnapshot.exists && systemSnapshot.exists;
    stateNotifier.state = stateNotifier.state.copyWith(
      user: stateNotifier.state.user.copyWith(
        publicData: publicSnapshot.data() as Map<String, dynamic>,
        privateData: privateSnapshot.data() as Map<String, dynamic>,
        systemData: systemSnapshot.data() as Map<String, dynamic>,
        hasCreatedProfile: hasCreatedProfile,
      ),
    );
  }
}
