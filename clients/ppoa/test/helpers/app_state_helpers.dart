// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:ppoa/business/services/mutator_service.dart';
import 'package:ppoa/business/services/system_service.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import '../mocks/routing/mock_router.dart';
import '../mocktail/fallback_helpers.dart';

Future<void> setTestServiceState(
  AppState state, {
  WidgetTester? widgetTester,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerMockFallbackValues();

  final GetIt locator = GetIt.I;
  await locator.reset();

  final AppStateNotifier appStateNotifier = AppStateNotifier(state: state);

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  locator.registerSingleton<Logger>(Logger());

  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);

  locator.registerSingleton<AppRouter>(MockRouter());

  locator.registerSingleton<MutatorService>(MutatorService());
  locator.registerSingleton<SystemService>(SystemService());
}
