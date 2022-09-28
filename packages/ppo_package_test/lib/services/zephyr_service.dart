import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

import '../constants/ppo_test_environment_variables.dart';

class ZephyrService {
  ZephyrService._privateConstructor();
  static final ZephyrService instance = ZephyrService._privateConstructor();

  late Dio dio;
  late ZephyrRestClient restClient;

  String _zephyrApiKey = '';
  String get zephyrApiKey => '';

  String _zephyrTestCycle = '';
  String get zephyrTestCycle => '';

  String _zephyrProjectName = '';
  String get zephyrProjectName => '';

  bool get isConnected => _zephyrApiKey.isNotEmpty && _zephyrTestCycle.isNotEmpty && _zephyrProjectName.isNotEmpty;

  String get bearerToken {
    if (!isConnected) {
      throw 'Not connected to Zephyr';
    }

    return 'Bearer $_zephyrApiKey';
  }

  final Map<String, ZephyrTestExecution> executions = <String, ZephyrTestExecution>{};

  Future<void> initializeService() async {
    dio = Dio();
    restClient = ZephyrRestClient(dio);

    _zephyrApiKey = Platform.environment[kTestKeyZephyrToken] ?? '';
    _zephyrTestCycle = Platform.environment[kTestKeyZephyrCycle] ?? '';
    _zephyrProjectName = Platform.environment[kTestKeyZephyrProject] ?? '';
  }

  void startTestExecution(String testCaseName) {
    if (!isConnected) {
      throw 'Not connected to Zephyr';
    }

    final ZephyrTestExecution testExecution = ZephyrTestExecution(
      projectKey: _zephyrProjectName,
      testCaseKey: testCaseName,
      testCycleKey: _zephyrTestCycle,
      statusName: kTestStatusNotExecuted,
    );

    executions[testCaseName] = testExecution;
  }

  void assertMutateTestCase(String testCaseName) {
    if (!isConnected || !executions.containsKey(testCaseName)) {
      throw 'Cannot publish to Zephyr, missing environment or test case';
    }
  }

  void updateTestStatus(String testCaseName, String newStatus) {
    assertMutateTestCase(testCaseName);
    final ZephyrTestExecution zephyrTestExecution = executions[testCaseName]!.copyWith(statusName: newStatus);
    executions[testCaseName] = zephyrTestExecution;
  }

  void appendTestScriptResult(String testCaseName, String statusName, String actualResult) {
    assertMutateTestCase(testCaseName);
    final ZephyrTestScriptResult zephyrTestScriptResult = ZephyrTestScriptResult(
      statusName: statusName,
      actualResult: actualResult,
    );

    final ZephyrTestExecution zephyrTestExecution = executions[testCaseName]!.copyWith(testScriptResults: [
      ...executions[testCaseName]!.testScriptResults,
      zephyrTestScriptResult,
    ]);
    executions[testCaseName] = zephyrTestExecution;
  }

  Future<void> publishExecution(String testCaseName) async {
    assertMutateTestCase(testCaseName);
    final ZephyrTestExecution zephyrTestExecution = executions[testCaseName]!;
    await restClient.publishTestExecution(zephyrTestExecution, bearerToken);
  }
}
