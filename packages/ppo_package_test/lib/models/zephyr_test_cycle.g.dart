// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zephyr_test_cycle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ZephyrTestCycle _$$_ZephyrTestCycleFromJson(Map<String, dynamic> json) =>
    _$_ZephyrTestCycle(
      id: json['id'] as int,
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      project:
          json['project'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      jiraProjectVersion: json['jiraProjectVersion'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      status:
          json['status'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      folder:
          json['folder'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      description: json['description'] as String? ?? '',
      plannedStartDate: json['plannedStartDate'] == null
          ? null
          : DateTime.parse(json['plannedStartDate'] as String),
      plannedEndDate: json['plannedEndDate'] == null
          ? null
          : DateTime.parse(json['plannedEndDate'] as String),
      owner:
          json['owner'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      customFields: json['customFields'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      links:
          json['links'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$$_ZephyrTestCycleToJson(_$_ZephyrTestCycle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'project': instance.project,
      'jiraProjectVersion': instance.jiraProjectVersion,
      'status': instance.status,
      'folder': instance.folder,
      'description': instance.description,
      'plannedStartDate': instance.plannedStartDate?.toIso8601String(),
      'plannedEndDate': instance.plannedEndDate?.toIso8601String(),
      'owner': instance.owner,
      'customFields': instance.customFields,
      'links': instance.links,
    };
