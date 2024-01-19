// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'positive_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PositivePlace _$PositivePlaceFromJson(Map<String, dynamic> json) {
  return _PositivePlace.fromJson(json);
}

/// @nodoc
mixin _$PositivePlace {
  String get description => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitudeCoordinates')
  String? get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitudeCoordinates')
  String? get longitude => throw _privateConstructorUsedError;
  bool get optOut => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PositivePlaceCopyWith<PositivePlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositivePlaceCopyWith<$Res> {
  factory $PositivePlaceCopyWith(
          PositivePlace value, $Res Function(PositivePlace) then) =
      _$PositivePlaceCopyWithImpl<$Res, PositivePlace>;
  @useResult
  $Res call(
      {String description,
      String placeId,
      @JsonKey(name: 'latitudeCoordinates') String? latitude,
      @JsonKey(name: 'longitudeCoordinates') String? longitude,
      bool optOut});
}

/// @nodoc
class _$PositivePlaceCopyWithImpl<$Res, $Val extends PositivePlace>
    implements $PositivePlaceCopyWith<$Res> {
  _$PositivePlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? optOut = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      optOut: null == optOut
          ? _value.optOut
          : optOut // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PositivePlaceImplCopyWith<$Res>
    implements $PositivePlaceCopyWith<$Res> {
  factory _$$PositivePlaceImplCopyWith(
          _$PositivePlaceImpl value, $Res Function(_$PositivePlaceImpl) then) =
      __$$PositivePlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      String placeId,
      @JsonKey(name: 'latitudeCoordinates') String? latitude,
      @JsonKey(name: 'longitudeCoordinates') String? longitude,
      bool optOut});
}

/// @nodoc
class __$$PositivePlaceImplCopyWithImpl<$Res>
    extends _$PositivePlaceCopyWithImpl<$Res, _$PositivePlaceImpl>
    implements _$$PositivePlaceImplCopyWith<$Res> {
  __$$PositivePlaceImplCopyWithImpl(
      _$PositivePlaceImpl _value, $Res Function(_$PositivePlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? optOut = null,
  }) {
    return _then(_$PositivePlaceImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      optOut: null == optOut
          ? _value.optOut
          : optOut // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositivePlaceImpl implements _PositivePlace {
  const _$PositivePlaceImpl(
      {this.description = '',
      this.placeId = '',
      @JsonKey(name: 'latitudeCoordinates') this.latitude,
      @JsonKey(name: 'longitudeCoordinates') this.longitude,
      this.optOut = false});

  factory _$PositivePlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositivePlaceImplFromJson(json);

  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String placeId;
  @override
  @JsonKey(name: 'latitudeCoordinates')
  final String? latitude;
  @override
  @JsonKey(name: 'longitudeCoordinates')
  final String? longitude;
  @override
  @JsonKey()
  final bool optOut;

  @override
  String toString() {
    return 'PositivePlace(description: $description, placeId: $placeId, latitude: $latitude, longitude: $longitude, optOut: $optOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositivePlaceImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.optOut, optOut) || other.optOut == optOut));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, description, placeId, latitude, longitude, optOut);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PositivePlaceImplCopyWith<_$PositivePlaceImpl> get copyWith =>
      __$$PositivePlaceImplCopyWithImpl<_$PositivePlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositivePlaceImplToJson(
      this,
    );
  }
}

abstract class _PositivePlace implements PositivePlace {
  const factory _PositivePlace(
      {final String description,
      final String placeId,
      @JsonKey(name: 'latitudeCoordinates') final String? latitude,
      @JsonKey(name: 'longitudeCoordinates') final String? longitude,
      final bool optOut}) = _$PositivePlaceImpl;

  factory _PositivePlace.fromJson(Map<String, dynamic> json) =
      _$PositivePlaceImpl.fromJson;

  @override
  String get description;
  @override
  String get placeId;
  @override
  @JsonKey(name: 'latitudeCoordinates')
  String? get latitude;
  @override
  @JsonKey(name: 'longitudeCoordinates')
  String? get longitude;
  @override
  bool get optOut;
  @override
  @JsonKey(ignore: true)
  _$$PositivePlaceImplCopyWith<_$PositivePlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
