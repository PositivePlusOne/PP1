// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) {
  return _UserLocation.fromJson(json);
}

/// @nodoc
mixin _$UserLocation {
  @JsonKey(name: '_latitude')
  num get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: '_longitude')
  num get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserLocationCopyWith<UserLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLocationCopyWith<$Res> {
  factory $UserLocationCopyWith(
          UserLocation value, $Res Function(UserLocation) then) =
      _$UserLocationCopyWithImpl<$Res, UserLocation>;
  @useResult
  $Res call(
      {@JsonKey(name: '_latitude') num latitude,
      @JsonKey(name: '_longitude') num longitude});
}

/// @nodoc
class _$UserLocationCopyWithImpl<$Res, $Val extends UserLocation>
    implements $UserLocationCopyWith<$Res> {
  _$UserLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserLocationCopyWith<$Res>
    implements $UserLocationCopyWith<$Res> {
  factory _$$_UserLocationCopyWith(
          _$_UserLocation value, $Res Function(_$_UserLocation) then) =
      __$$_UserLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_latitude') num latitude,
      @JsonKey(name: '_longitude') num longitude});
}

/// @nodoc
class __$$_UserLocationCopyWithImpl<$Res>
    extends _$UserLocationCopyWithImpl<$Res, _$_UserLocation>
    implements _$$_UserLocationCopyWith<$Res> {
  __$$_UserLocationCopyWithImpl(
      _$_UserLocation _value, $Res Function(_$_UserLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_UserLocation(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as num,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserLocation implements _UserLocation {
  const _$_UserLocation(
      {@JsonKey(name: '_latitude') required this.latitude,
      @JsonKey(name: '_longitude') required this.longitude});

  factory _$_UserLocation.fromJson(Map<String, dynamic> json) =>
      _$$_UserLocationFromJson(json);

  @override
  @JsonKey(name: '_latitude')
  final num latitude;
  @override
  @JsonKey(name: '_longitude')
  final num longitude;

  @override
  String toString() {
    return 'UserLocation(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserLocation &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserLocationCopyWith<_$_UserLocation> get copyWith =>
      __$$_UserLocationCopyWithImpl<_$_UserLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserLocationToJson(
      this,
    );
  }
}

abstract class _UserLocation implements UserLocation {
  const factory _UserLocation(
          {@JsonKey(name: '_latitude') required final num latitude,
          @JsonKey(name: '_longitude') required final num longitude}) =
      _$_UserLocation;

  factory _UserLocation.fromJson(Map<String, dynamic> json) =
      _$_UserLocation.fromJson;

  @override
  @JsonKey(name: '_latitude')
  num get latitude;
  @override
  @JsonKey(name: '_longitude')
  num get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_UserLocationCopyWith<_$_UserLocation> get copyWith =>
      throw _privateConstructorUsedError;
}
