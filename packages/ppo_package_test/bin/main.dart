import 'package:dio/dio.dart';

import 'package:ppo_package_test/clients/zephyr_rest_client.dart';
import 'package:ppo_package_test/models/zephyr_test_execution.dart';
import 'package:retrofit/dio.dart';

Future<void> main() async {
  final Dio dio = Dio();
  final ZephyrRestClient zephyrRestClient = ZephyrRestClient(dio);

  const String token = '';

  // final ZephyrPaginatedResults cycleResult = await zephyrRestClient.getTestCycles('SAND', token);
  // final List<ZephyrTestCycle> cycles = cycleResult.values.map((e) => ZephyrTestCycle.fromJson(e)).toList();
  // print(cycles);

  // final ZephyrPaginatedResults caseResults = await zephyrRestClient.getTestCases('SAND', token);
  // final List<ZephyrTestCase> cases = caseResults.values.map((e) => ZephyrTestCase.fromJson(e)).toList();
  // print(cases);

  const ZephyrTestScriptResult result = ZephyrTestScriptResult(
    actualResult: 'Failed test 1',
    statusName: 'Fail',
  );

  const ZephyrTestExecution testExecution = ZephyrTestExecution(
    projectKey: 'SAND',
    testCaseKey: 'SAND-T9',
    testCycleKey: 'SAND-R2',
    statusName: 'Fail',
    comment: 'Testing API',
    testScriptResults: <ZephyrTestScriptResult>[
      result,
    ],
  );

  try {
    final HttpResponse response = await zephyrRestClient.publishTestExecution(testExecution, token);
    // ignore: avoid_print
    print(response);
  } catch (ex) {
    // ignore: avoid_print
    print(ex);
  }
}
