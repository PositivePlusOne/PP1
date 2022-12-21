// Flutter imports:
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

// Project imports:
import 'package:ppoa/business/services/system_service.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../client/routing/app_router.gr.dart';
import '../state/app_state.dart';
import 'mutator_service.dart';

Future<void> prepareState(EnvironmentType environmentType) async {
  // Configure some UI properties
  WidgetsFlutterBinding.ensureInitialized();

  final AppState initialState = AppState.initialState(
    environmentType: environmentType,
  );

  final GetIt locator = GetIt.instance;
  final AppStateNotifier appStateNotifier = AppStateNotifier(state: initialState);

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  // Inject notifier
  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);

  // Prepare Domain Services
  locator.registerSingleton(MutatorService());
  locator.registerSingleton(SystemService());

  // Prepare Third Party Services
  locator.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  locator.registerSingleton<AppRouter>(AppRouter());

  //* Some code cannot be ran on desktop, and hence their function is disabled.
  if (Platform.isAndroid || Platform.isIOS) {
    Logger.root.info('Connecting to Firebase...');
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();

    //* Uncomment this line to use the firebase emulators
    //* Run this command to start it: firebase emulators:start --inspect-functions
    // const String host = '192.168.50.70';
    // FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    // FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    // FirebaseAuth.instance.useAuthEmulator(host, 9099);

    locator.registerSingleton<FirebaseApp>(Firebase.app());
    locator.registerSingleton<FirebaseAppCheck>(FirebaseAppCheck.instance);
    locator.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    locator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    locator.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
    locator.registerSingleton<GoogleSignIn>(GoogleSignIn(
      scopes: [
        'email',
      ],
    ));
  }
}
