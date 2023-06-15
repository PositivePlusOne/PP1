// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) {
  return _LocationDto.fromJson(json);
}

/// @nodoc
mixin _$LocationDto {
  num get latitude => throw _privateConstructorUsedError;
  num get longitude => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get locality => throw _privateConstructorUsedError;
  String get subLocality => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  String get administrativeArea => throw _privateConstructorUsedError;
  String get subAdministrativeArea => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationDtoCopyWith<LocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationDtoCopyWith<$Res> {
  factory $LocationDtoCopyWith(
          LocationDto value, $Res Function(LocationDto) then) =
      _$LocationDtoCopyWithImpl<$Res, LocationDto>;
  @useResult
  $Res call(
      {num latitude,
      num longitude,
      String description,
      String locality,
      String subLocality,
      String postalCode,
      String administrativeArea,
      String subAdministrativeArea,
      String country});
}

/// @nodoc
class _$LocationDtoCopyWithImpl<$Res, $Val extends LocationDto>
    implements $LocationDtoCopyWith<$Res> {
  _$LocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? locality = null,
    Object? subLocality = null,
    Object? postalCode = null,
    Object? administrativeArea = null,
    Object? subAdministrativeArea = null,
    Object? country = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as num,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as num,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      locality: null == locality
          ? _value.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String,
      subLocality: null == subLocality
          ? _value.subLocality
          : subLocality // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      administrativeArea: null == administrativeArea
          ? _value.administrativeArea
          : administrativeArea // ignore: cast_nullable_to_non_nullable
              as String,
      subAdministrativeArea: null == subAdministrativeArea
          ? _value.subAdministrativeArea
          : subAdministrativeArea // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LocationDtoCopyWith<$Res>
    implements $LocationDtoCopyWith<$Res> {
  factory _$$_LocationDtoCopyWith(
          _$_LocationDto value, $Res Function(_$_LocationDto) then) =
      __$$_LocationDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num latitude,
      num longitude,
      String description,
      String locality,
      String subLocality,
      String postalCode,
      String administrativeArea,
      String subAdministrativeArea,
      String country});
}

/// @nodoc
class __$$_LocationDtoCopyWithImpl<$Res>
    extends _$LocationDtoCopyWithImpl<$Res, _$_LocationDto>
    implements _$$_LocationDtoCopyWith<$Res> {
  __$$_LocationDtoCopyWithImpl(
      _$_LocationDto _value, $Res Function(_$_LocationDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? locality = null,
    Object? subLocality = null,
    Object? postalCode = null,
    Object? administrativeArea = null,
    Object? subAdministrativeArea = null,
    Object? country = null,
  }) {
    return _then(_$_LocationDto(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as num,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as num,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      locality: null == locality
          ? _value.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String,
      subLocality: null == subLocality
          ? _value.subLocality
          : subLocality // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      administrativeArea: null == administrativeArea
          ? _value.administrativeArea
          : administrativeArea // ignore: cast_nullable_to_non_nullable
              as String,
      subAdministrativeArea: null == subAdministrativeArea
          ? _value.subAdministrativeArea
          : subAdministrativeArea // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LocationDto implements _LocationDto {
  const _$_LocationDto(
      {this.latitude = 0.0,
      this.longitude = 0.0,
      this.description = '',
      this.locality = '',
      this.subLocality = '',
      this.postalCode = '',
      this.administrativeArea = '',
      this.subAdministrativeArea = '',
      this.country = ''});

  factory _$_LocationDto.fromJson(Map<String, dynamic> json) =>
      _$$_LocationDtoFromJson(json);

  @override
  @JsonKey()
  final num latitude;
  @override
  @JsonKey()
  final num longitude;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String locality;
  @override
  @JsonKey()
  final String subLocality;
  @override
  @JsonKey()
  final String postalCode;
  @override
  @JsonKey()
  final String administrativeArea;
  @override
  @JsonKey()
  final String subAdministrativeArea;
  @override
  @JsonKey()
  final String country;

  @override
  String toString() {
    return 'LocationDto(latitude: $latitude, longitude: $longitude, description: $description, locality: $locality, subLocality: $subLocality, postalCode: $postalCode, administrativeArea: $administrativeArea, subAdministrativeArea: $subAdministrativeArea, country: $country)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocationDto &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.subLocality, subLocality) ||
                other.subLocality == subLocality) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.administrativeArea, administrativeArea) ||
                other.administrativeArea == administrativeArea) &&
            (identical(other.subAdministrativeArea, subAdministrativeArea) ||
                other.subAdministrativeArea == subAdministrativeArea) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      latitude,
      longitude,
      description,
      locality,
      subLocality,
      postalCode,
      administrativeArea,
      subAdministrativeArea,
      country);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocationDtoCopyWith<_$_LocationDto> get copyWith =>
      __$$_LocationDtoCopyWithImpl<_$_LocationDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocationDtoToJson(
      this,
    );
  }
}

abstract class _LocationDto implements LocationDto {
  const factory _LocationDto(
      {final num latitude,
      final num longitude,
      final String description,
      final String locality,
      final String subLocality,
      final String postalCode,
      final String administrativeArea,
      final String subAdministrativeArea,
      final String country}) = _$_LocationDto;

  factory _LocationDto.fromJson(Map<String, dynamic> json) =
      _$_LocationDto.fromJson;

  @override
  num get latitude;
  @override
  num get longitude;
  @override
  String get description;
  @override
  String get locality;
  @override
  String get subLocality;
  @override
  String get postalCode;
  @override
  String get administrativeArea;
  @override
  String get subAdministrativeArea;
  @override
  String get country;
  @override
  @JsonKey(ignore: true)
  _$$_LocationDtoCopyWith<_$_LocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}
