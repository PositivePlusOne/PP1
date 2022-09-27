import 'package:freezed_annotation/freezed_annotation.dart';

part 'zephyr_test_execution.freezed.dart';
part 'zephyr_test_execution.g.dart';

@freezed
class ZephyrTestExecution with _$ZephyrTestExecution {
  const factory ZephyrTestExecution({
    required String projectKey,
    required String testCaseKey,
    required String testCycleKey,
    required String statusName,
    @Default(<ZephyrTestScriptResult>[]) List<ZephyrTestScriptResult> testScriptResults,
    String? environmentName,
    DateTime? actualEndDate,
    @Default(0) int executionTime,
    @Default('') String executedById,
    @Default('') String assignedToId,
    @Default('') String comment,
    @Default(<String, dynamic>{}) Map<String, dynamic> customFields,
  }) = _ZephyrTestExecution;

  factory ZephyrTestExecution.fromJson(Map<String, dynamic> json) => _$ZephyrTestExecutionFromJson(json);
}

@freezed
class ZephyrTestScriptResult with _$ZephyrTestScriptResult {
  const factory ZephyrTestScriptResult({
    @Default('') String statusName,
    DateTime? actualEndDate,
    @Default('') String actualResult,
  }) = _ZephyrTestScriptResult;

  factory ZephyrTestScriptResult.fromJson(Map<String, dynamic> json) => _$ZephyrTestScriptResultFromJson(json);
}
