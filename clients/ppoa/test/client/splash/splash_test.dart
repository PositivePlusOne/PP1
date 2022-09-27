// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Project imports:
import 'package:ppoa/business/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/splash/splash_connector.dart';
import 'package:ppoa/client/splash/splash_keys.dart';
import '../builders/mock_state_builder.dart';
import '../helpers/presentation_helpers.dart';

void main() => group('Splash page', () {
      testGoldens('Golden render - static', generateStaticGolden);
      testWidgets('Render check - static', testRender, tags: <String>['smoke']);
    });

Future<void> generateStaticGolden(WidgetTester widgetTester) async {
  // Arrange
  const SplashConnector splashConnector = SplashConnector();
  final MockStateBuilder stateBuilder = MockStateBuilder()..withEnvironmentType(EnvironmentType.test);
  final AppState appState = stateBuilder.state;

  // Act and Assert
  await wrapReduxStoreAndPerformGoldenCheck('splash_page', widgetTester, splashConnector, appState);
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
