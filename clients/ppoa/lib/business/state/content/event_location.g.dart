// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventLocation _$$_EventLocationFromJson(Map<String, dynamic> json) =>
    _$_EventLocation(
      eventLatitude: (json['event_latitude'] as num?)?.toDouble() ?? double.nan,
      eventLongitude:
          (json['event_longitude'] as num?)?.toDouble() ?? double.nan,
      locationFirstLine: json['location_first_line'] as String? ?? '',
      locationCity: json['location_city'] as String? ?? '',
      locationTown: json['location_town'] as String? ?? '',
      locationCountry: json['location_country'] as String? ?? '',
      locationZipCode: json['location_zip_code'] as String? ?? '',
    );

Map<String, dynamic> _$$_EventLocationToJson(_$_EventLocation instance) =>
    <String, dynamic>{
      'event_latitude': instance.eventLatitude,
      'event_longitude': instance.eventLongitude,
      'location_first_line': instance.locationFirstLine,
      'location_city': instance.locationCity,
      'location_town': instance.locationTown,
      'location_country': instance.locationCountry,
      'location_zip_code': instance.locationZipCode,
    };
