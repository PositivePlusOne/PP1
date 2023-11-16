// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EndpointResponseImpl _$$EndpointResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$EndpointResponseImpl(
      data: json['data'] as Map<String, dynamic>? ?? const {},
      cursor: json['cursor'] as String?,
      limit: json['limit'] as int? ?? 10,
    );

Map<String, dynamic> _$$EndpointResponseImplToJson(
        _$EndpointResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'cursor': instance.cursor,
      'limit': instance.limit,
    };
