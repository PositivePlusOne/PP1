// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlMeta _$$_FlMetaFromJson(Map<String, dynamic> json) => _$_FlMeta(
      createdBy: json['createdBy'] as String?,
      createdDate: dateFromUnknown(json['createdDate']),
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: dateFromUnknown(json['lastModifiedDate']),
      lastFetchDate: dateFromUnknown(json['lastFetchDate']),
      isPartial: json['isPartial'] as bool? ?? true,
      docId: json['docId'] as String?,
      id: json['fl_id'] as String?,
      env: json['env'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      schema: json['schema'] as String? ?? '',
      schemaRefId: json['schemaRefId'] as String?,
    );

Map<String, dynamic> _$$_FlMetaToJson(_$_FlMeta instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': dateToUnknown(instance.createdDate),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': dateToUnknown(instance.lastModifiedDate),
      'lastFetchDate': dateToUnknown(instance.lastFetchDate),
      'isPartial': instance.isPartial,
      'docId': instance.docId,
      'fl_id': instance.id,
      'env': instance.env,
      'locale': instance.locale,
      'schema': instance.schema,
      'schemaRefId': instance.schemaRefId,
    };
