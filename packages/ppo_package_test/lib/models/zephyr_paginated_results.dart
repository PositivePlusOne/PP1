import 'package:freezed_annotation/freezed_annotation.dart';

part 'zephyr_paginated_results.freezed.dart';
part 'zephyr_paginated_results.g.dart';

@freezed
class ZephyrPaginatedResults with _$ZephyrPaginatedResults {
  const factory ZephyrPaginatedResults({
    String? next,
    @Default(0) int startAt,
    @Default(0) int maxResults,
    @Default(0) int total,
    @Default(true) bool isLast,
    @Default([<String, dynamic>{}]) List<Map<String, dynamic>> values,
  }) = _ZephyrPaginatedResults;

  factory ZephyrPaginatedResults.fromJson(Map<String, dynamic> json) => _$ZephyrPaginatedResultsFromJson(json);
}
