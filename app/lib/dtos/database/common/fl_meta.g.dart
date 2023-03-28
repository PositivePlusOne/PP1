// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlMeta _$$_FlMetaFromJson(Map<String, dynamic> json) => _$_FlMeta(
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
      docId: json['doc_id'] as String?,
      env: json['env'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      schema: json['schema'] as String? ?? '',
      schemaRefId: json['schema_ref_id'] as String?,
      updatedBy: json['updated_by'] as String?,
      updatedDate: json['updated_date'] as String?,
    );

Map<String, dynamic> _$$_FlMetaToJson(_$_FlMeta instance) => <String, dynamic>{
      'created_by': instance.createdBy,
      'created_date': instance.createdDate,
      'doc_id': instance.docId,
      'env': instance.env,
      'locale': instance.locale,
      'schema': instance.schema,
      'schema_ref_id': instance.schemaRefId,
      'updated_by': instance.updatedBy,
      'updated_date': instance.updatedDate,
    };
