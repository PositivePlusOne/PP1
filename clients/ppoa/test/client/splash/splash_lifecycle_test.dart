import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';
import 'package:collection/collection.dart';

import '../../business/helpers/app_state_helpers.dart';

void main() {
  test('Can bootstrap application from splash page successfully', testBootstrap);
}

Future<void> testBootstrap() async {
  final SplashLifecycle splashLifecycle = SplashLifecycle();
  final AppState initialState = AppState.initialState(environmentType: EnvironmentType.test);

  await setTestServiceState(initialState);
  await splashLifecycle.bootstrapApplication();

  final AppStateNotifier notifier = GetIt.instance.get();
  final AppState mutatedAppState = notifier.state;

  final Map<String, dynamic> baseJson = initialState.toJson();
  final Map<String, dynamic> mutatedJson = mutatedAppState.toJson();
  const DeepCollectionEquality deepCollectionEquality = DeepCollectionEquality();

  expect(deepCollectionEquality.equals(baseJson, mutatedJson), isFalse);
}
