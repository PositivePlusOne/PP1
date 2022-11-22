// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flamelink_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlamelinkMeta _$$_FlamelinkMetaFromJson(Map<String, dynamic> json) =>
    _$_FlamelinkMeta(
      createdBy: json['created_by'] as String,
      timestamp: firestoreTimestampFromJson(json['timestamp']),
      documentId: json['docId'] as String,
      flamelinkId: json['fl_id'] as String,
      environment: json['env'] as String,
      lastModifiedBy: json['last_modified_by'] as String,
      lastModifiedDate: firestoreTimestampFromJson(json['last_modified_date']),
      schema: json['schema'] as String,
      schemaReference: firestoreDocRefFromJson(json['schemaRef']),
      schemaType: json['schema_type'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$_FlamelinkMetaToJson(_$_FlamelinkMeta instance) =>
    <String, dynamic>{
      'created_by': instance.createdBy,
      'timestamp': firestoreTimestampToJson(instance.timestamp),
      'docId': instance.documentId,
      'fl_id': instance.flamelinkId,
      'env': instance.environment,
      'last_modified_by': instance.lastModifiedBy,
      'last_modified_date': firestoreTimestampToJson(instance.lastModifiedDate),
      'schema': instance.schema,
      'schemaRef': firestoreDocRefToJson(instance.schemaReference),
      'schema_type': instance.schemaType,
      'status': instance.status,
    };
