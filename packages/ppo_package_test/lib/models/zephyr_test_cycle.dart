import 'package:freezed_annotation/freezed_annotation.dart';

part 'zephyr_test_cycle.freezed.dart';
part 'zephyr_test_cycle.g.dart';

@freezed
class ZephyrTestCycle with _$ZephyrTestCycle {
  const factory ZephyrTestCycle({
    required int id,
    @Default('') String key,
    @Default('') String name,
    @Default(<String, dynamic>{}) Map<String, dynamic> project,
    @Default(<String, dynamic>{}) Map<String, dynamic> jiraProjectVersion,
    @Default(<String, dynamic>{}) Map<String, dynamic> status,
    @Default(<String, dynamic>{}) Map<String, dynamic> folder,
    @Default('') String description,
    DateTime? plannedStartDate,
    DateTime? plannedEndDate,
    @Default(<String, dynamic>{}) Map<String, dynamic> owner,
    @Default(<String, dynamic>{}) Map<String, dynamic> customFields,
    @Default(<String, dynamic>{}) Map<String, dynamic> links,
  }) = _ZephyrTestCycle;

  factory ZephyrTestCycle.fromJson(Map<String, dynamic> json) => _$ZephyrTestCycleFromJson(json);
}
