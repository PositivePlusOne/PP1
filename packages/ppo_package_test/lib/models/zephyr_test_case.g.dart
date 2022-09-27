// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zephyr_test_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ZephyrTestCase _$$_ZephyrTestCaseFromJson(Map<String, dynamic> json) =>
    _$_ZephyrTestCase(
      id: json['id'] as int,
      key: json['key'] as String,
      name: json['name'] as String,
      project:
          json['project'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      objective: json['objective'] as String? ?? '',
      precondition: json['precondition'] as String? ?? '',
      estimatedTime: json['estimatedTime'] as int? ?? 0,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      component: json['component'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      priority: json['priority'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      status:
          json['status'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      folder:
          json['folder'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      owner:
          json['owner'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      testScript: json['testScript'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      customFields: json['customFields'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      links:
          json['links'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$$_ZephyrTestCaseToJson(_$_ZephyrTestCase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'project': instance.project,
      'createdOn': instance.createdOn?.toIso8601String(),
      'objective': instance.objective,
      'precondition': instance.precondition,
      'estimatedTime': instance.estimatedTime,
      'labels': instance.labels,
      'component': instance.component,
      'priority': instance.priority,
      'status': instance.status,
      'folder': instance.folder,
      'owner': instance.owner,
      'testScript': instance.testScript,
      'customFields': instance.customFields,
      'links': instance.links,
    };
