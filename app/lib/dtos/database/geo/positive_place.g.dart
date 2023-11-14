// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positive_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositivePlaceImpl _$$PositivePlaceImplFromJson(Map<String, dynamic> json) =>
    _$PositivePlaceImpl(
      description: json['description'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
      latitude: json['latitudeCoordinates'] as String?,
      longitude: json['longitudeCoordinates'] as String?,
      optOut: json['optOut'] as bool? ?? false,
    );

Map<String, dynamic> _$$PositivePlaceImplToJson(_$PositivePlaceImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'placeId': instance.placeId,
      'latitudeCoordinates': instance.latitude,
      'longitudeCoordinates': instance.longitude,
      'optOut': instance.optOut,
    };
