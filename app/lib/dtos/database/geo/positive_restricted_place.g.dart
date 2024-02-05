// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positive_restricted_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositiveRestrictedPlaceImpl _$$PositiveRestrictedPlaceImplFromJson(
        Map<String, dynamic> json) =>
    _$PositiveRestrictedPlaceImpl(
      enforcementType: json['enforcementType'] == null
          ? const PositiveRestrictedPlaceEnforcementType.unknown()
          : PositiveRestrictedPlaceEnforcementType.fromJson(
              json['enforcementType'] as String),
      enforcementMatcher: json['enforcementMatcher'] == null
          ? const PositiveRestrictedPlaceEnforcementMatcher.unknown()
          : PositiveRestrictedPlaceEnforcementMatcher.fromJson(
              json['enforcementMatcher'] as String),
      enforcementValue: json['enforcementValue'] as String? ?? '',
    );

Map<String, dynamic> _$$PositiveRestrictedPlaceImplToJson(
        _$PositiveRestrictedPlaceImpl instance) =>
    <String, dynamic>{
      'enforcementType': PositiveRestrictedPlaceEnforcementType.toJson(
          instance.enforcementType),
      'enforcementMatcher': PositiveRestrictedPlaceEnforcementMatcher.toJson(
          instance.enforcementMatcher),
      'enforcementValue': instance.enforcementValue,
    };
