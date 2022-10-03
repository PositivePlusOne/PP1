// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zephyr_paginated_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ZephyrPaginatedResults _$$_ZephyrPaginatedResultsFromJson(
        Map<String, dynamic> json) =>
    _$_ZephyrPaginatedResults(
      next: json['next'] as String?,
      startAt: json['startAt'] as int? ?? 0,
      maxResults: json['maxResults'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      isLast: json['isLast'] as bool? ?? true,
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [<String, dynamic>{}],
    );

Map<String, dynamic> _$$_ZephyrPaginatedResultsToJson(
        _$_ZephyrPaginatedResults instance) =>
    <String, dynamic>{
      'next': instance.next,
      'startAt': instance.startAt,
      'maxResults': instance.maxResults,
      'total': instance.total,
      'isLast': instance.isLast,
      'values': instance.values,
    };
