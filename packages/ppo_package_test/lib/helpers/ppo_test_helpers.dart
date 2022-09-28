import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

/*
* Uses Zephyr to create an execution on a test case, if the environment is setup to do so.
*/
Future<void> runZephyrTest(String testCaseName, Future<void> Function() testExecution) async {
  String status = kTestStatusPassed;

  if (ZephyrService.instance.isConnected) {
    ZephyrService.instance.startTestExecution(testCaseName);
  }

  Object? caughtException;

  try {
    await testExecution();
  } catch (ex) {
    caughtException = ex;
    status = kTestStatusFail;
  }

  if (ZephyrService.instance.isConnected) {
    'Sending test result to Zephyr'.logDebug();
    ZephyrService.instance.updateTestStatus(testCaseName, status);
    await ZephyrService.instance.publishExecution(testCaseName);
  }

  if (caughtException != null) {
    throw caughtException;
  }
}
