// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flamelink_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlamelinkBaseModel _$$_FlamelinkBaseModelFromJson(
        Map<String, dynamic> json) =>
    _$_FlamelinkBaseModel(
      metadata:
          FlamelinkMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      id: json['id'] as String,
      order: json['order'] as int,
      parentId: json['parent_id'] as int,
    );

Map<String, dynamic> _$$_FlamelinkBaseModelToJson(
        _$_FlamelinkBaseModel instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.metadata,
      'id': instance.id,
      'order': instance.order,
      'parent_id': instance.parentId,
    };
