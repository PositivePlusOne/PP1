import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';

import '../../client/routing/app_router.gr.dart';
import '../state/app_state.dart';
import '../state/environment/models/environment.dart';

Future<void> prepareState(EnvironmentType environmentType) async {
  final AppState initialState = AppState.initialState(
    environment: Environment(type: environmentType),
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

  // Prepare Third Party Services
  locator.registerSingleton<AppRouter>(AppRouter());
}
