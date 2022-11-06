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
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T313', 'Can render Primary buttons across test devices', testPrimaryButtons);
  testZephyrWidgets('PP1-T314', 'Can render Secondary buttons across test devices', testSecondaryButtons);
  testZephyrWidgets('PP1-T315', 'Can render Tertiary buttons across test devices', testTertiaryButtons);
  testZephyrWidgets('PP1-T316', 'Can render Ghost buttons across test devices', testGhostButtons);
  testZephyrWidgets('PP1-T317', 'Can render Minor buttons across test devices', testMinorButtons);
  testZephyrWidgets('PP1-T318', 'Can render Text buttons across test devices', testTextButtons);
  testZephyrWidgets('PP1-T319', 'Can render Label buttons across test devices', testLabelButtons);
  testZephyrWidgets('PP1-T320', 'Can render Large Icon buttons across test devices', testLargeIconButtons);
  testZephyrWidgets('PP1-T321', 'Can render Navigation buttons across test devices', testLargeNavigationButtons);
  testZephyrWidgets('PP1-T322', 'Can render and tap a button with a result when enabled', testButtonEnabledState);
  testZephyrWidgets('PP1-T323', 'Can render and tap a button with no result when disabled', testButtonDisabledState);
}

Future<void> testButtonDisabledState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  bool result = false;
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final Scaffold widget = Scaffold(
    body: Center(
      child: PPOButton(
        brand: appState.designSystem.brand,
        label: 'Test',
        onTapped: () async => result = true,
        layout: PPOButtonLayout.textOnly,
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

Future<void> testButtonEnabledState(WidgetTester widgetTester, String testCaseName) async {
  // Arrange
  bool result = false;
  final AppState appState = AppState.initialState(environmentType: EnvironmentType.test);
  final Scaffold widget = Scaffold(
    body: Center(
      child: PPOButton(
        brand: appState.designSystem.brand,
        label: 'Test',
        onTapped: () async => result = true,
        layout: PPOButtonLayout.textOnly,
      ),
    ),
  );

  // Act
  await pumpWidgetWithProviderScopeAndServices(widget, appState, widgetTester);
  await widgetTester.tap(find.text('Test'));

  // Assert
  expect(result, true);
}

Future<void> testLargeNavigationButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 8, widgetTester);
}

Future<void> testLargeIconButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 7, widgetTester);
}

Future<void> testLabelButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 6, widgetTester);
}

Future<void> testTextButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 5, widgetTester);
}

Future<void> testMinorButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 4, widgetTester);
}

Future<void> testGhostButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 3, widgetTester);
}

Future<void> testTertiaryButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 2, widgetTester);
}

Future<void> testSecondaryButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 1, widgetTester);
}

Future<void> testPrimaryButtons(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 0, widgetTester);
}

Future<void> _renderAndScroll(String testCaseName, int page, WidgetTester tester) async {
  final PPOButtonTestView widget = PPOButtonTestView(initialPage: page);

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
