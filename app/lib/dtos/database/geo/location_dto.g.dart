// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocationDto _$$_LocationDtoFromJson(Map<String, dynamic> json) =>
    _$_LocationDto(
      latitude: json['latitude'] as num? ?? 0.0,
      longitude: json['longitude'] as num? ?? 0.0,
      description: json['description'] as String? ?? '',
      locality: json['locality'] as String? ?? '',
      subLocality: json['subLocality'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      administrativeArea: json['administrativeArea'] as String? ?? '',
      subAdministrativeArea: json['subAdministrativeArea'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$$_LocationDtoToJson(_$_LocationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'locality': instance.locality,
      'subLocality': instance.subLocality,
      'postalCode': instance.postalCode,
      'administrativeArea': instance.administrativeArea,
      'subAdministrativeArea': instance.subAdministrativeArea,
      'country': instance.country,
    };
