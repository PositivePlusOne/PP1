// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/splash/splash_keys.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import '../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T287', 'Verify the Splash page can render successfully given correct data', testRender);
}

Future<void> testRender(WidgetTester widgetTester) async {
  // Arrange
  const SplashPage splashPage = SplashPage();
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);

  // Act
  await pumpWidgetWithProviderScopeAndServices(splashPage, appState, widgetTester);

  // Assert
  final Finder renderFinder = find.byKey(kPageSplashScaffoldKey);
  expect(renderFinder, findsOneWidget);
}
