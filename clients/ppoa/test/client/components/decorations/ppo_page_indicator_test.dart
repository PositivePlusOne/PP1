// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T338', 'Can render Page Indicators across test devices', testPageIndicators);
}

Future<void> testPageIndicators(WidgetTester widgetTester, String testCaseName) async {
  await _renderAndScroll(testCaseName, 0, widgetTester);
}

Future<void> _renderAndScroll(String testCaseName, int page, WidgetTester tester) async {
  const PPOPageIndicatorTestView widget = PPOPageIndicatorTestView();

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
