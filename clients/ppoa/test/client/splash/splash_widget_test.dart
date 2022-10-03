// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/business/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/splash/splash_connector.dart';
import 'package:ppoa/client/splash/splash_keys.dart';
import '../builders/mock_state_builder.dart';
import '../helpers/presentation_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T287', 'Verify the Splash page can render successfully given correct data', testRender);
}

Future<void> testRender(WidgetTester widgetTester) async {
  // Arrange
  const SplashConnector splashConnector = SplashConnector();
  final MockStateBuilder stateBuilder = MockStateBuilder()..withEnvironmentType(EnvironmentType.test);
  final AppState appState = stateBuilder.state;

  // Act
  await wrapReduxStoreAndPump(widgetTester, splashConnector, appState);

  // Assert
  final Finder renderFinder = find.byKey(kPageSplashScaffoldKey);
  expect(renderFinder, findsOneWidget);
}
