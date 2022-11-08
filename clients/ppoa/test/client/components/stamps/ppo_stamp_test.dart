// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/stamps/ppo_stamps_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('', 'Can render Victory Stamps animated across test devices', testStampsVictory);
  testZephyrWidgets('', 'Can render Fist Stamps animated across test devices', testStampsFist);
  testZephyrWidgets('', 'Can render Positive Stamps animated across test devices', testStampsPositive);
  testZephyrWidgets('', 'Can render Smile Stamps animated across test devices', testStampsSmile);
}

Future<void> testStampsVictory(WidgetTester widgetTester, String testCaseName) async {
// Creates the sample test page, setting the tab to the one I want to render
  await renderStampWidget(widgetTester, testCaseName, 0);
}

Future<void> testStampsFist(WidgetTester widgetTester, String testCaseName) async {
// Creates the sample test page, setting the tab to the one I want to render
  await renderStampWidget(widgetTester, testCaseName, 1);
}

Future<void> testStampsPositive(WidgetTester widgetTester, String testCaseName) async {
// Creates the sample test page, setting the tab to the one I want to render
  await renderStampWidget(widgetTester, testCaseName, 2);
}

Future<void> testStampsSmile(WidgetTester widgetTester, String testCaseName) async {
// Creates the sample test page, setting the tab to the one I want to render
  await renderStampWidget(widgetTester, testCaseName, 3);
}

Future<void> renderStampWidget(WidgetTester widgetTester, String testCaseName, int page) async {
  // Creates the sample test page, setting the tab to the one I want to render
  final PPOStampTestView widget = PPOStampTestView(initialPage: page);

  // Loop over all devices
  for (final DeviceInfo device in commonTestDevices) {
    final String description = 'Can render on ${device.name}';

    try {
      // Set the device (screen size, pixels, etc)
      await setTestDevice(device);

      // Put the page on the virtual screen
      await pumpWidgetWithProviderScopeAndServices(widget, null, widgetTester);

      //* You can completely leave this out, it depends if you put the badges in a list view so they can scroll
      final ListView listView = widgetTester.widget<ListView>(find.byType(ListView));
      final ScrollController? controller = listView.controller;
      expect(controller, isNotNull);

      // Same here, this is to make sure said list view is scroll to the bottom
      await widgetTester.drag(find.byType(ListView), Offset(0, controller!.position.maxScrollExtent));

      // If scrolling or rendering do not throw an exception, then write the pass result to ZephyrScale
      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusPassed, description);
    } catch (ex) {
      // Writes the device and failure state to ZephyrScale
      ZephyrService.instance.appendTestScriptResult(testCaseName, kTestStatusFail, ex.toString());
    }
  }
}
