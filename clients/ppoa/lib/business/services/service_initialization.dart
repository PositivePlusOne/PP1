// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ppoa/business/services/system_service.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:universal_io/io.dart';
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

    locator.registerSingleton<FirebaseApp>(Firebase.app());
    locator.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    locator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    locator.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
    locator.registerSingleton<GoogleSignIn>(GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ));
  }
}
