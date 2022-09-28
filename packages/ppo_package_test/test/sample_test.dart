import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

void main() => runSuite();

Future<void> runSuite() async {
  //* Setup Zephyr
  final ZephyrService zephyrService = ZephyrService.instance;
  await zephyrService.initializeService();

  //* Run tests
  test('Run an example zephyr test execution against a cycle', () => runZephyrTest('SAND-T9', () => runSampleTest()));
}

Future<void> runSampleTest() async {
  ZephyrService.instance.appendTestScriptResult('SAND-T9', 'Fail', 'Failed due to test 2');
  expect(true, false);
}
