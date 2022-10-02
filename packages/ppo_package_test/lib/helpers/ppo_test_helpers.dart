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
  Future<void> Function(WidgetTester) test, {
  bool? skip,
  Object? tags = _defaultTagObject,
}) =>
    testWidgets(
      description,
      (WidgetTester tester) => _runZephyrWidgetTest(testCaseName, tester, test),
    );

@isTest
void testZephyr(
  String testCaseName,
  String description,
  Future<void> Function() testExecution, {
  bool? skip,
  Object? tags = _defaultTagObject,
}) =>
    test(
      description,
      () => _runZephyrTest(testCaseName, testExecution),
    );

Future<void> _runZephyrTest(String testCaseName, Future<void> Function() testExecution) async {
  String status = kTestStatusPassed;

  await ZephyrService.instance.initializeService();
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
    ZephyrService.instance.updateTestStatus(testCaseName, status);
    await ZephyrService.instance.publishExecution(testCaseName);
  }

  if (caughtException != null) {
    throw caughtException;
  }
}

Future<void> _runZephyrWidgetTest(String testCaseName, WidgetTester widgetTester, Future<void> Function(WidgetTester tester) testExecution) async {
  String status = kTestStatusPassed;

  await ZephyrService.instance.initializeService(overrideHttp: true);
  if (ZephyrService.instance.isConnected) {
    ZephyrService.instance.startTestExecution(testCaseName);
  }

  Object? caughtException;

  try {
    await testExecution(widgetTester);
  } catch (ex) {
    caughtException = ex;
    status = kTestStatusFail;
  }

  if (ZephyrService.instance.isConnected) {
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
