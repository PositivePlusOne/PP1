// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Pagination _$$_PaginationFromJson(Map<String, dynamic> json) =>
    _$_Pagination(
      limit: json['limit'] as int?,
      cursor: json['cursor'] as String?,
    );

Map<String, dynamic> _$$_PaginationToJson(_$_Pagination instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'cursor': instance.cursor,
    };
