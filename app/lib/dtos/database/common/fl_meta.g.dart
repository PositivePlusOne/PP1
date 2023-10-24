// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlMetaImpl _$$FlMetaImplFromJson(Map<String, dynamic> json) => _$FlMetaImpl(
      createdBy: json['createdBy'] as String?,
      createdDate: dateFromUnknown(json['createdDate']),
      ownedBy: json['ownedBy'] as String?,
      ownedAsOfDate: dateFromUnknown(json['ownedAsOfDate']),
      directoryEntryId: json['directoryEntryId'] as String? ?? '',
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: dateFromUnknown(json['lastModifiedDate']),
      lastFetchMillis: json['lastFetchMillis'] as int? ?? -1,
      isPartial: json['isPartial'] as bool? ?? false,
      docId: json['docId'] as String?,
      id: json['fl_id'] as String?,
      env: json['env'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      schema: json['schema'] as String? ?? '',
      schemaRefId: json['schemaRefId'] as String?,
    );

Map<String, dynamic> _$$FlMetaImplToJson(_$FlMetaImpl instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'ownedBy': instance.ownedBy,
      'ownedAsOfDate': instance.ownedAsOfDate,
      'directoryEntryId': instance.directoryEntryId,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'lastFetchMillis': instance.lastFetchMillis,
      'isPartial': instance.isPartial,
      'docId': instance.docId,
      'fl_id': instance.id,
      'env': instance.env,
      'locale': instance.locale,
      'schema': instance.schema,
      'schemaRefId': instance.schemaRefId,
    };
