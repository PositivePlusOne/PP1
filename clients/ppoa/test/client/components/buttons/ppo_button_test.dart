import 'package:auto_route/annotations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button_test_view.dart';

import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T313', 'Can render primary buttons across test devices', testPrimaryButtons);
  testZephyrWidgets('PP1-T314', 'Can render secondary buttons across test devices', testSecondaryButtons);
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
