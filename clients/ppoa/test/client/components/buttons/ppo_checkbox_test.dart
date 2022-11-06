// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T327', 'Can render large checkboxes across test devices', testLargeCheckboxes);
  testZephyrWidgets('PP1-T328', 'Can render small checkboxes across test devices', testSmallCheckboxes);
  testZephyrWidgets('PP1-T329', 'Can render and tap a checkbox with a result when enabled', testCheckboxEnabledState);
  testZephyrWidgets('PP1-T330', 'Can render and tap a checkbox with no result when disabled', testCheckboxDisabledState);
}

Future<void> testCheckboxDisabledState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  bool result = false;
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final Scaffold widget = Scaffold(
    body: Center(
      child: PPOCheckbox(
        brand: appState.designSystem.brand,
        label: 'Test',
        onTapped: () async => result = true,
        isDisabled: true,
      ),
    ),
  );

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  await widgetTester.tap(find.text('Test'), warnIfMissed: false);

  // Assert
  expect(result, false);
}

Future<void> testCheckboxEnabledState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  bool result = false;
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final Scaffold widget = Scaffold(
    body: Center(
      child: PPOCheckbox(
        brand: appState.designSystem.brand,
        label: 'Test',
        onTapped: () async => result = true,
        isDisabled: false,
      ),
    ),
  );

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  await widgetTester.tap(find.text('Test'));

  // Assert
  expect(result, true);
}

Future<void> testSmallCheckboxes(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 1, widgetTester);
}

Future<void> testLargeCheckboxes(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 0, widgetTester);
}

Future<void> _renderAndScroll(String testCaseName, int page, WidgetTester tester) async {
  final PPOCheckboxTestView widget = PPOCheckboxTestView(initialPage: page);

  for (final DeviceInfo device in commonTestDevices) {
    final String description = 'Can render on ${device.name}';

    try {
      await setTestDevice(device);
      await pumpWidgetWithProviderScopeAndServices(widget, null, tester);

      //* This should find the presenter listview, despite there being a few offstage
      final ListView listView = tester.widget<ListView>(find.byType(ListView));
      final ScrollController? controller = listView.controller;
      expect(controller, isNotNull);

      await tester.drag(find.byType(ListView), Offset(0, controller!.position.maxScrollExtent));
      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusPassed, description);
    } catch (ex) {
      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusFail, ex.toString());
    }
  }
}
