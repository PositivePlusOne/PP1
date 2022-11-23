// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../client/routing/app_router.gr.dart';
import '../state/app_state.dart';
import 'mutator_service.dart';

Future<void> prepareState(EnvironmentType environmentType) async {
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

  // Prepare Third Party Services
  locator.registerSingleton<AppRouter>(AppRouter());
  locator.registerSingleton<FirebaseApp>(Firebase.app());
  locator.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
}
