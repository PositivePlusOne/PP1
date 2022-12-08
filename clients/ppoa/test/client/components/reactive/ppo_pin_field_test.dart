// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field_test_page.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  // testZephyrWidgets('', 'Can render Pin Field across test devices', testPinFieldRenderState);
  testZephyrWidgets('', 'Can interact with Pin Field across test devices', testPinFieldFocus);
}

Future<void> testPinFieldRenderState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  const Widget widget = PPOPinFieldTestPage();

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  final Finder pinFinder = find.byType(PPOPinField);

  // Assert
  expect(pinFinder, findsOneWidget);
}

Future<void> testPinFieldFocus(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final FocusNode focusNode = FocusNode();
  final Widget widget = Scaffold(
    body: PPOPinField(
      focusNode: focusNode,
      onSubmittion: (_) {},
    ),
  );

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  // final Finder pinFinder = find.byType(PPOPinField);
  final Finder gestureDetector = find.byType(GestureDetector);
  expect(gestureDetector, findsOneWidget);
  await widgetTester.pumpAndSettle();
  await widgetTester.tap(gestureDetector);
  await widgetTester.pumpAndSettle();

  // Assert
  expect(focusNode.hasFocus, true);
}

Future<void> testPinFieldLogicState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  bool result = false;
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  String returnString = "";
  const Widget widget = PPOPinFieldTestPage();

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  // await widgetTester.tap(find.byWidget());

  // Assert
  expect(result, true);
}
