// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positive_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositivePlaceImpl _$$PositivePlaceImplFromJson(Map<String, dynamic> json) =>
    _$PositivePlaceImpl(
      description: json['description'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      optOut: json['optOut'] as bool? ?? false,
    );

Map<String, dynamic> _$$PositivePlaceImplToJson(_$PositivePlaceImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'placeId': instance.placeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'optOut': instance.optOut,
    };
