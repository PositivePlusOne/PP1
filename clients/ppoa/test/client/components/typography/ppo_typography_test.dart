// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/client/simulation/views/ppo_typography_test_page.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('PP1-T336', 'Can render typography across test devices', testTypographyRender);
}

Future<void> testTypographyRender(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(testCaseName, widgetTester);
}

Future<void> _renderPage(String testCaseName, WidgetTester tester) async {
  const PPOTypographyTestPage widget = PPOTypographyTestPage();

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
