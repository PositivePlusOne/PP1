// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EndpointResponse _$$_EndpointResponseFromJson(Map<String, dynamic> json) =>
    _$_EndpointResponse(
      data: json['data'] as Map<String, dynamic>? ?? const [],
      cursor: json['cursor'] as String?,
      limit: json['limit'] as int? ?? 10,
    );

Map<String, dynamic> _$$_EndpointResponseToJson(_$_EndpointResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'cursor': instance.cursor,
      'limit': instance.limit,
    };
