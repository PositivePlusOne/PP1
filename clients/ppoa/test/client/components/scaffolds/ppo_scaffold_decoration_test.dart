// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

// Project imports:
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold_decoration_test_view.dart';
import '../../helpers/test_device_helpers.dart';
import '../../helpers/widget_tester_helpers.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyrWidgets('', 'Can render scaffold decorations with offsets, scales, and rotations', testDecorationRender);
}

Future<void> testDecorationRender(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(testCaseName, widgetTester);
}

Future<void> _renderPage(String testCaseName, WidgetTester tester) async {
  const PPOScaffoldDecorationTestView widget = PPOScaffoldDecorationTestView();

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
