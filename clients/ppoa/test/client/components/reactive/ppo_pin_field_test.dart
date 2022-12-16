// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field_test_page.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('', 'Can render Pin Field', testPinFieldRenderState);
  testZephyrWidgets('', 'Can interact with Pin Field', testPinFieldFocus);
  testZephyrWidgets('', 'Can auto focus Pin Field', testPinFieldAutoFocus);
  testZephyrWidgets('', 'Can get return String from Pin Field', testPinFieldLogicState);
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
  final Widget widget = Material(
    child: PPOPinField(
      branding: appState.designSystem.brand,
      focusNode: focusNode,
      onChanged: (_) {},
    ),
  );

  // Act
  await setTestDevice(Devices.ios.iPhone13ProMax);
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);

  final Finder gestureDetectorFinder = find.byType(GestureDetector);
  final GestureDetector gestureDetector = widgetTester.widget(gestureDetectorFinder);

  //! Something is very wrong with tapping a gesture detector (dunno why)
  //! We will cover this manually.
  gestureDetector.onTap!();

  await widgetTester.pumpAndSettle();

  // Assert
  expect(focusNode.hasFocus, true);
}

Future<void> testPinFieldAutoFocus(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final FocusNode focusNode = FocusNode();
  final Widget widget = Material(
    child: PPOPinField(
      branding: appState.designSystem.brand,
      focusNode: focusNode,
      requestFocusOnRender: true,
      onChanged: (_) {},
    ),
  );

  // Act
  await setTestDevice(Devices.ios.iPhone13ProMax);
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);

  // Assert
  expect(focusNode.hasFocus, true);
}

Future<void> testPinFieldLogicState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  String returnText = '';
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final FocusNode focusNode = FocusNode();
  final Widget widget = Material(
    child: PPOPinField(
      branding: appState.designSystem.brand,
      focusNode: focusNode,
      onChanged: (String pin) => returnText = pin,
    ),
  );

  // Act
  await setTestDevice(Devices.ios.iPhone13ProMax);
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);

  final Finder gestureDetectorFinder = find.byType(GestureDetector);
  final GestureDetector gestureDetector = widgetTester.widget(gestureDetectorFinder);
  gestureDetector.onTap!();

  //* Pretend keyboard lalala
  await widgetTester.pumpAndSettle();

  final Finder textFieldFinder = find.byType(TextField, skipOffstage: false);
  expect(textFieldFinder, findsOneWidget);

  await widgetTester.enterText(textFieldFinder, '123456');
  final TextField textField = widgetTester.widget(textFieldFinder);
  final TextEditingController textEditingController = textField.controller!;

  // Assert
  expect(textEditingController.text, '123456');
  expect(returnText, '123456');
}
