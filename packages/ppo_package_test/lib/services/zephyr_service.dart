import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

class ZephyrService {
  ZephyrService._privateConstructor();
  static final ZephyrService instance = ZephyrService._privateConstructor();

  Dio? dio;
  ZephyrRestClient? restClient;

  String _zephyrApiKey = '';
  String get zephyrApiKey => _zephyrApiKey;

  String _zephyrTestCycle = kTestKeyZephyrDefaultCycle;
  String get zephyrTestCycle => _zephyrTestCycle;

  String _zephyrProjectName = kTestKeyZephyrDefaultProject;
  String get zephyrProjectName => _zephyrProjectName;

  String _zephyrUserId = '';
  String get zephyrUserId => _zephyrUserId;

  String _zephyrEnvironmentName = kTestKeyZephyrDefaultEnvName;
  String get zephyrEnvironmentName => _zephyrEnvironmentName;

  String _zephyrBranchName = kTestKeyZephyrDefaultBranchName;
  String get zephyrBranchName => _zephyrBranchName;

  bool get isConnected => _zephyrApiKey.isNotEmpty && _zephyrTestCycle.isNotEmpty && _zephyrProjectName.isNotEmpty;

  String get bearerToken {
    if (!isConnected) {
      throw 'Not connected to Zephyr';
    }

    return 'Bearer $_zephyrApiKey';
  }

  final Map<String, ZephyrTestExecution> executions = <String, ZephyrTestExecution>{};

  Future<void> initializeService({bool overrideHttp = false}) async {
    if (dio != null) {
      return;
    }

    final BaseOptions options = BaseOptions(
      connectTimeout: 5 * 1000,
      receiveTimeout: 5 * 1000,
      sendTimeout: 5 * 1000,
    );

    dio = Dio(options);
    restClient = ZephyrRestClient(dio!);

    _zephyrApiKey = Platform.environment[kTestKeyZephyrToken] ?? '';
    _zephyrTestCycle = Platform.environment[kTestKeyZephyrCycle] ?? kTestKeyZephyrDefaultCycle;
    _zephyrProjectName = Platform.environment[kTestKeyZephyrProject] ?? kTestKeyZephyrDefaultProject;
    _zephyrUserId = Platform.environment[kTestKeyZephyrUserId] ?? '';
    _zephyrEnvironmentName = Platform.environment[kTestKeyZephyrEnvName] ?? kTestKeyZephyrDefaultEnvName;
    _zephyrBranchName = Platform.environment[kTestKeyZephyrBranchName] ?? kTestKeyZephyrDefaultBranchName;

    //* This prevents the async HTTP calls in Flutter widget tests from being mocked
    if (overrideHttp) {
      HttpOverrides.global = null;
    }
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
      environmentName: _zephyrEnvironmentName,
      executedById: _zephyrUserId,
      customFields: <String, dynamic>{
        kTestKeyZephyrCustomFieldBranchName: _zephyrBranchName,
      },
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
    if (!isConnected) {
      return;
    }

    assertMutateTestCase(testCaseName);
    final ZephyrTestScriptResult zephyrTestScriptResult = ZephyrTestScriptResult(
      statusName: statusName,
      actualResult: actualResult,
    );

    final ZephyrTestExecution zephyrTestExecution = executions[testCaseName]!.copyWith(
      testScriptResults: <ZephyrTestScriptResult>[
        ...executions[testCaseName]!.testScriptResults,
        zephyrTestScriptResult,
      ],
    );

    executions[testCaseName] = zephyrTestExecution;
  }

  Future<void> publishExecution(String testCaseName, {bool attemptCreate = true}) async {
    assertMutateTestCase(testCaseName);
    final ZephyrTestExecution zephyrTestExecution = executions[testCaseName]!;

    if (zephyrTestExecution.testScriptResults.isEmpty) {
      throw 'Missing test script results';
    }

    await restClient?.publishTestExecution(zephyrTestExecution, bearerToken);
  }
}
