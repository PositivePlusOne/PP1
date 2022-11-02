import 'package:flutter_test/flutter_test.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

void main() => runSuite();

Future<void> runSuite() async {
  testZephyr('SAND-T9', 'Run an example zephyr test execution against a cycle', runSampleTest);
}

Future<void> runSampleTest(String testCaseName) async {
  ZephyrService.instance.appendTestScriptResult('SAND-T9', 'Fail', 'Test environment 2');
  expect(true, false);
}
