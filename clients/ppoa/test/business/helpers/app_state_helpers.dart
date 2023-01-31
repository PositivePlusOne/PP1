// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/services/system_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import '../../client/routing/mocks/mock_router.dart';
import '../../mocktail/fallback_helpers.dart';

Future<void> setTestServiceState(
  AppState state, {
  WidgetTester? widgetTester,
}) async {
  registerMockFallbackValues();

  final GetIt locator = GetIt.I;
  await locator.reset();

  final AppStateNotifier appStateNotifier = AppStateNotifier(state: state);

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  late final SharedPreferences sharedPreferences;
  if (widgetTester != null) {
    await widgetTester.runAsync(() async => sharedPreferences = await SharedPreferences.getInstance());
  } else {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  await sharedPreferences.clear();

  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  locator.registerSingleton<AppRouter>(MockRouter());

  locator.registerSingleton<MutatorService>(MutatorService());
  locator.registerSingleton<SystemService>(SystemService());
}
