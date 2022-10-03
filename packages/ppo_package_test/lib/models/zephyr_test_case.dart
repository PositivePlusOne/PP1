import 'package:freezed_annotation/freezed_annotation.dart';

part 'zephyr_test_case.freezed.dart';
part 'zephyr_test_case.g.dart';

@freezed
class ZephyrTestCase with _$ZephyrTestCase {
  const factory ZephyrTestCase({
    required int id,
    required String key,
    required String name,
    @Default(<String, dynamic>{}) Map<String, dynamic> project,
    DateTime? createdOn,
    @Default('') String objective,
    @Default('') String precondition,
    @Default(0) int estimatedTime,
    @Default(<String>[]) List<String> labels,
    @Default(<String, dynamic>{}) Map<String, dynamic> component,
    @Default(<String, dynamic>{}) Map<String, dynamic> priority,
    @Default(<String, dynamic>{}) Map<String, dynamic> status,
    @Default(<String, dynamic>{}) Map<String, dynamic> folder,
    @Default(<String, dynamic>{}) Map<String, dynamic> owner,
    @Default(<String, dynamic>{}) Map<String, dynamic> testScript,
    @Default(<String, dynamic>{}) Map<String, dynamic> customFields,
    @Default(<String, dynamic>{}) Map<String, dynamic> links,
  }) = _ZephyrTestCase;

  factory ZephyrTestCase.fromJson(Map<String, dynamic> json) => _$ZephyrTestCaseFromJson(json);
}
