// Package imports:
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';

Future<void> setTestServiceState(AppState state) async {
  final GetIt locator = GetIt.I;
  await locator.reset();

  final AppStateNotifier appStateNotifier = AppStateNotifier(state: state);

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);
}
