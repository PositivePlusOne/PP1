import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ppo_package_test/ppo_package_test.dart';

/// The default tag parameter. The parameter
/// is allowed to be null so we need something to compare against.
const Object _defaultTagObject = Object();

@isTest
void testZephyrWidgets(
  String testCaseName,
  String description,
  Future<void> Function(WidgetTester widgetTest, String testCaseName) test, {
  bool? skip,
  Object? tags = _defaultTagObject,
}) =>
    testWidgets(
      description,
      (WidgetTester tester) => _runZephyrWidgetTest(testCaseName, description, tester, test),
    );

@isTest
void testZephyr(
  String testCaseName,
  String description,
  Future<void> Function(String) testExecution, {
  bool? skip,
  Object? tags = _defaultTagObject,
}) =>
    test(
      description,
      () => _runZephyrTest(testCaseName, description, testExecution),
    );

Future<void> _runZephyrTest(String testCaseName, String description, Future<void> Function(String testCaseName) testExecution) async {
  String status = kTestStatusPassed;

  if (testCaseName.isNotEmpty) {
    await ZephyrService.instance.initializeService();
    if (ZephyrService.instance.isConnected) {
      ZephyrService.instance.startTestExecution(testCaseName);
    }
  }

  Object? caughtException;

  try {
    await testExecution(testCaseName);
  } catch (ex) {
    caughtException = ex;
    status = kTestStatusFail;
  }

  if (testCaseName.isNotEmpty && ZephyrService.instance.isConnected) {
    ZephyrService.instance.appendTestScriptResult(testCaseName, status, description);
    ZephyrService.instance.updateTestStatus(testCaseName, status);
    await ZephyrService.instance.publishExecution(testCaseName);
  }

  if (caughtException != null) {
    throw caughtException;
  }
}

Future<void> _runZephyrWidgetTest(String testCaseName, String description, WidgetTester widgetTester, Future<void> Function(WidgetTester tester, String testCaseName) testExecution) async {
  String status = kTestStatusPassed;

  if (testCaseName.isNotEmpty) {
    await ZephyrService.instance.initializeService(overrideHttp: true);
    if (ZephyrService.instance.isConnected) {
      ZephyrService.instance.startTestExecution(testCaseName);
    }
  }

  Object? caughtException;

  try {
    await testExecution(widgetTester, testCaseName);
  } catch (ex) {
    caughtException = ex;
    status = kTestStatusFail;
  }

  if (testCaseName.isNotEmpty && ZephyrService.instance.isConnected) {
    ZephyrService.instance.appendTestScriptResult(testCaseName, status, description);
    ZephyrService.instance.updateTestStatus(testCaseName, status);
    await widgetTester.runAsync(() async {
      HttpOverrides.global = null;
      await ZephyrService.instance.publishExecution(testCaseName);
    });
  }

  if (caughtException != null) {
    throw caughtException;
  }
}
