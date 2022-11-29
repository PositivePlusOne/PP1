// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';
import '../helpers/widget_tester_helpers.dart';

void main() {
  testZephyrWidgets('', 'Can bootstrap application from splash page successfully', testBootstrap);
}

Future<void> testBootstrap(WidgetTester tester, String testCaseName) async {
  final SplashLifecycle splashLifecycle = SplashLifecycle();
  final AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);

  await pumpWidgetWithProviderScopeAndServices(const Scaffold(), initialState, tester);

  await splashLifecycle.bootstrapApplication();

  final AppStateNotifier notifier = GetIt.instance.get();
  final AppState mutatedAppState = notifier.state;

  final Map<String, dynamic> baseJson = initialState.toJson();
  final Map<String, dynamic> mutatedJson = mutatedAppState.toJson();
  const DeepCollectionEquality deepCollectionEquality = DeepCollectionEquality();

  expect(deepCollectionEquality.equals(baseJson, mutatedJson), isFalse);
}
