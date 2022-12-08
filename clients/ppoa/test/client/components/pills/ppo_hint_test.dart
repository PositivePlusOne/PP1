// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/components/atoms/pills/ppo_hint.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T347', 'Can render hint pill with icon on a page', testRenderHint);
}

Future<void> testRenderHint(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final Scaffold widget = Scaffold(
    body: Center(
      child: PPOHint(
        brand: appState.designSystem.brand,
        label: 'Test',
        icon: Icons.abc,
        iconColor: Colors.red,
      ),
    ),
  );

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);

  // Assert
  expect(find.text('Test'), findsOneWidget);
  expect(find.byIcon(Icons.abc), findsOneWidget);
}
