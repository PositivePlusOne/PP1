// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'positive_restricted_place.freezed.dart';
part 'positive_restricted_place.g.dart';

@freezed
class PositiveRestrictedPlace with _$PositiveRestrictedPlace {
  const factory PositiveRestrictedPlace({
    @Default(PositiveRestrictedPlaceEnforcementType.unknown()) @JsonKey(fromJson: PositiveRestrictedPlaceEnforcementType.fromJson, toJson: PositiveRestrictedPlaceEnforcementType.toJson) PositiveRestrictedPlaceEnforcementType enforcementType,
    @Default(PositiveRestrictedPlaceEnforcementMatcher.unknown()) @JsonKey(fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson, toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson) PositiveRestrictedPlaceEnforcementMatcher enforcementMatcher,
    @Default('') String enforcementValue,
  }) = _PositiveRestrictedPlace;

  factory PositiveRestrictedPlace.empty() => const PositiveRestrictedPlace();
  factory PositiveRestrictedPlace.fromJson(Map<String, Object?> json) => _$PositiveRestrictedPlaceFromJson(json);

  static PositiveRestrictedPlace fromJsonSafe(Map<String, Object?> json) {
    try {
      return PositiveRestrictedPlace.fromJson(json);
    } catch (e) {
      return PositiveRestrictedPlace.empty();
    }
  }

  static List<PositiveRestrictedPlace> fromJsonList(List<dynamic> data) {
    return data.map((e) => PositiveRestrictedPlace.fromJsonSafe(e as Map<String, Object?>)).toList();
  }

  static List<Map<String, Object?>> toJsonList(List<PositiveRestrictedPlace> data) {
    return data.map((e) => e.toJson()).toList();
  }
}

@freezed
class PositiveRestrictedPlaceEnforcementMatcher with _$PositiveRestrictedPlaceEnforcementMatcher {
  const factory PositiveRestrictedPlaceEnforcementMatcher.equal() = _PositiveRestrictedPlaceEnforcementMatcherEqual;
  const factory PositiveRestrictedPlaceEnforcementMatcher.notEqual() = _PositiveRestrictedPlaceEnforcementMatcherNotEqual;
  const factory PositiveRestrictedPlaceEnforcementMatcher.lessThan() = _PositiveRestrictedPlaceEnforcementMatcherLessThan;
  const factory PositiveRestrictedPlaceEnforcementMatcher.lessThanOrEqual() = _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual;
  const factory PositiveRestrictedPlaceEnforcementMatcher.greaterThan() = _PositiveRestrictedPlaceEnforcementMatcherGreaterThan;
  const factory PositiveRestrictedPlaceEnforcementMatcher.greaterThanOrEqual() = _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual;
  const factory PositiveRestrictedPlaceEnforcementMatcher.unknown() = _PositiveRestrictedPlaceEnforcementMatcherUnknown;

  static String toJson(PositiveRestrictedPlaceEnforcementMatcher? mode) {
    if (mode == null) {
      return '';
    }

    return mode.when(
      equal: () => '==',
      notEqual: () => '!=',
      lessThan: () => '<',
      lessThanOrEqual: () => '<=',
      greaterThan: () => '>',
      greaterThanOrEqual: () => '>=',
      unknown: () => '',
    );
  }

  factory PositiveRestrictedPlaceEnforcementMatcher.fromJson(String value) {
    switch (value) {
      case '==':
        return const _PositiveRestrictedPlaceEnforcementMatcherEqual();
      case '!=':
        return const _PositiveRestrictedPlaceEnforcementMatcherNotEqual();
      case '<':
        return const _PositiveRestrictedPlaceEnforcementMatcherLessThan();
      case '<=':
        return const _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual();
      case '>':
        return const _PositiveRestrictedPlaceEnforcementMatcherGreaterThan();
      case '>=':
        return const _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual();
      default:
        return const _PositiveRestrictedPlaceEnforcementMatcherUnknown();
    }
  }
}

@freezed
class PositiveRestrictedPlaceEnforcementType with _$PositiveRestrictedPlaceEnforcementType {
  const factory PositiveRestrictedPlaceEnforcementType.administrativeAreaLevelOne() = _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne;
  const factory PositiveRestrictedPlaceEnforcementType.administrativeAreaLevelTwo() = _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo;
  const factory PositiveRestrictedPlaceEnforcementType.country() = _PositiveRestrictedPlaceEnforcementTypeCountry;
  const factory PositiveRestrictedPlaceEnforcementType.locality() = _PositiveRestrictedPlaceEnforcementTypeLocality;
  const factory PositiveRestrictedPlaceEnforcementType.distance() = _PositiveRestrictedPlaceEnforcementTypeDistance;
  const factory PositiveRestrictedPlaceEnforcementType.unknown() = _PositiveRestrictedPlaceEnforcementTypeUnknown;

  static String toJson(PositiveRestrictedPlaceEnforcementType? mode) {
    if (mode == null) {
      return '';
    }

    return mode.when(
      administrativeAreaLevelOne: () => 'administrative_area_level_1',
      administrativeAreaLevelTwo: () => 'administrative_area_level_2',
      country: () => 'country',
      locality: () => 'locality',
      distance: () => 'distance',
      unknown: () => '',
    );
  }

  factory PositiveRestrictedPlaceEnforcementType.fromJson(String value) {
    switch (value) {
      case 'administrative_area_level_1':
        return const _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne();
      case 'administrative_area_level_2':
        return const _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo();
      case 'country':
        return const _PositiveRestrictedPlaceEnforcementTypeCountry();
      case 'locality':
        return const _PositiveRestrictedPlaceEnforcementTypeLocality();
      case 'distance':
        return const _PositiveRestrictedPlaceEnforcementTypeDistance();
      default:
        return const _PositiveRestrictedPlaceEnforcementTypeUnknown();
    }
  }

  static List<PositiveRestrictedPlaceEnforcementType> fromJsonList(List<dynamic> data) {
    return data.map((e) => PositiveRestrictedPlaceEnforcementType.fromJson(e as String)).toList();
  }

  static List<String> toJsonList(List<PositiveRestrictedPlaceEnforcementType> data) {
    return data.map((e) => PositiveRestrictedPlaceEnforcementType.toJson(e)).toList();
  }
}
