// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zephyr_test_execution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ZephyrTestExecution _$$_ZephyrTestExecutionFromJson(
        Map<String, dynamic> json) =>
    _$_ZephyrTestExecution(
      projectKey: json['projectKey'] as String,
      testCaseKey: json['testCaseKey'] as String,
      testCycleKey: json['testCycleKey'] as String,
      statusName: json['statusName'] as String,
      testScriptResults: (json['testScriptResults'] as List<dynamic>?)
              ?.map((e) =>
                  ZephyrTestScriptResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ZephyrTestScriptResult>[],
      environmentName: json['environmentName'] as String?,
      actualEndDate: json['actualEndDate'] == null
          ? null
          : DateTime.parse(json['actualEndDate'] as String),
      executionTime: json['executionTime'] as int? ?? 0,
      executedById: json['executedById'] as String? ?? '',
      assignedToId: json['assignedToId'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      customFields: json['customFields'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$$_ZephyrTestExecutionToJson(
        _$_ZephyrTestExecution instance) =>
    <String, dynamic>{
      'projectKey': instance.projectKey,
      'testCaseKey': instance.testCaseKey,
      'testCycleKey': instance.testCycleKey,
      'statusName': instance.statusName,
      'testScriptResults': instance.testScriptResults,
      'environmentName': instance.environmentName,
      'actualEndDate': instance.actualEndDate?.toIso8601String(),
      'executionTime': instance.executionTime,
      'executedById': instance.executedById,
      'assignedToId': instance.assignedToId,
      'comment': instance.comment,
      'customFields': instance.customFields,
    };

_$_ZephyrTestScriptResult _$$_ZephyrTestScriptResultFromJson(
        Map<String, dynamic> json) =>
    _$_ZephyrTestScriptResult(
      statusName: json['statusName'] as String? ?? '',
      actualEndDate: json['actualEndDate'] == null
          ? null
          : DateTime.parse(json['actualEndDate'] as String),
      actualResult: json['actualResult'] as String? ?? '',
    );

Map<String, dynamic> _$$_ZephyrTestScriptResultToJson(
        _$_ZephyrTestScriptResult instance) =>
    <String, dynamic>{
      'statusName': instance.statusName,
      'actualEndDate': instance.actualEndDate?.toIso8601String(),
      'actualResult': instance.actualResult,
    };
