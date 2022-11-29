// Package imports:
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/state/app_state.dart';

import '../../client/routing/mocks/mock_router.dart';

Future<void> setTestServiceState(AppState state) async {
  final GetIt locator = GetIt.I;
  await locator.reset();

  final AppStateNotifier appStateNotifier = AppStateNotifier(state: state);
  final MutatorService mutatorService = MutatorService();

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();

  final MockRouter router = MockRouter();

  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);
  locator.registerSingleton<MutatorService>(mutatorService);
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
  locator.registerSingleton<AppRouter>(router);
}
