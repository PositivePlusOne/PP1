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
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T324', 'Can render standard glass pane across test devices', testStandardGlassRender);
  testZephyrWidgets('PP1-T325', 'Can render dismissible glass pane across test devices', testDismissGlassRender);
  testZephyrWidgets('PP1-T326', 'Can get glass pane dismiss callback on user tap', testPaneCallback);
}

Future<void> testPaneCallback(WidgetTester widgetTester, String testCaseName) async {
  bool result = false;
  final AppState state = AppState.initialState(environmentType: EnvironmentType.test);

  final PPOGlassContainer widget = PPOGlassContainer(
    brand: state.designSystem.brand,
    onDismissRequested: () async => result = true,
    children: const <Widget>[
      Text('Testing'),
    ],
  );

  await setTestDevice(Devices.ios.iPhone13ProMax);
  await pumpWidgetWithProviderScopeAndServices(widget, state, widgetTester);

  final Finder finder = find.byType(IconButton);
  await widgetTester.tap(finder);

  expect(result, isTrue);
}

Future<void> testStandardGlassRender(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(testCaseName, 0, widgetTester);
}

Future<void> testDismissGlassRender(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(testCaseName, 1, widgetTester);
}

Future<void> _renderPage(String testCaseName, int page, WidgetTester tester) async {
  final PPOGlassContainerTestView widget = PPOGlassContainerTestView(initialPage: page);

  for (final DeviceInfo device in commonTestDevices) {
    final String description = 'Can render on ${device.name}';

    try {
      await setTestDevice(device);
      await pumpWidgetWithProviderScopeAndServices(widget, null, tester);

      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusPassed, description);
    } catch (ex) {
      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusFail, ex.toString());
    }
  }
}
