// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LocationOption {
  String get description => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocationOptionCopyWith<LocationOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationOptionCopyWith<$Res> {
  factory $LocationOptionCopyWith(
          LocationOption value, $Res Function(LocationOption) then) =
      _$LocationOptionCopyWithImpl<$Res, LocationOption>;
  @useResult
  $Res call({String description, String placeId});
}

/// @nodoc
class _$LocationOptionCopyWithImpl<$Res, $Val extends LocationOption>
    implements $LocationOptionCopyWith<$Res> {
  _$LocationOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationOptionImplCopyWith<$Res>
    implements $LocationOptionCopyWith<$Res> {
  factory _$$LocationOptionImplCopyWith(_$LocationOptionImpl value,
          $Res Function(_$LocationOptionImpl) then) =
      __$$LocationOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String placeId});
}

/// @nodoc
class __$$LocationOptionImplCopyWithImpl<$Res>
    extends _$LocationOptionCopyWithImpl<$Res, _$LocationOptionImpl>
    implements _$$LocationOptionImplCopyWith<$Res> {
  __$$LocationOptionImplCopyWithImpl(
      _$LocationOptionImpl _value, $Res Function(_$LocationOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
  }) {
    return _then(_$LocationOptionImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LocationOptionImpl implements _LocationOption {
  const _$LocationOptionImpl(
      {required this.description, required this.placeId});

  @override
  final String description;
  @override
  final String placeId;

  @override
  String toString() {
    return 'LocationOption(description: $description, placeId: $placeId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationOptionImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, placeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationOptionImplCopyWith<_$LocationOptionImpl> get copyWith =>
      __$$LocationOptionImplCopyWithImpl<_$LocationOptionImpl>(
          this, _$identity);
}

abstract class _LocationOption implements LocationOption {
  const factory _LocationOption(
      {required final String description,
      required final String placeId}) = _$LocationOptionImpl;

  @override
  String get description;
  @override
  String get placeId;
  @override
  @JsonKey(ignore: true)
  _$$LocationOptionImplCopyWith<_$LocationOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationControllerState {
  PermissionStatus? get locationPermission =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocationControllerStateCopyWith<LocationControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationControllerStateCopyWith<$Res> {
  factory $LocationControllerStateCopyWith(LocationControllerState value,
          $Res Function(LocationControllerState) then) =
      _$LocationControllerStateCopyWithImpl<$Res, LocationControllerState>;
  @useResult
  $Res call({PermissionStatus? locationPermission});
}

/// @nodoc
class _$LocationControllerStateCopyWithImpl<$Res,
        $Val extends LocationControllerState>
    implements $LocationControllerStateCopyWith<$Res> {
  _$LocationControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationPermission = freezed,
  }) {
    return _then(_value.copyWith(
      locationPermission: freezed == locationPermission
          ? _value.locationPermission
          : locationPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationControllerStateImplCopyWith<$Res>
    implements $LocationControllerStateCopyWith<$Res> {
  factory _$$LocationControllerStateImplCopyWith(
          _$LocationControllerStateImpl value,
          $Res Function(_$LocationControllerStateImpl) then) =
      __$$LocationControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PermissionStatus? locationPermission});
}

/// @nodoc
class __$$LocationControllerStateImplCopyWithImpl<$Res>
    extends _$LocationControllerStateCopyWithImpl<$Res,
        _$LocationControllerStateImpl>
    implements _$$LocationControllerStateImplCopyWith<$Res> {
  __$$LocationControllerStateImplCopyWithImpl(
      _$LocationControllerStateImpl _value,
      $Res Function(_$LocationControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationPermission = freezed,
  }) {
    return _then(_$LocationControllerStateImpl(
      locationPermission: freezed == locationPermission
          ? _value.locationPermission
          : locationPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
    ));
  }
}

/// @nodoc

class _$LocationControllerStateImpl implements _LocationControllerState {
  const _$LocationControllerStateImpl({this.locationPermission});

  @override
  final PermissionStatus? locationPermission;

  @override
  String toString() {
    return 'LocationControllerState(locationPermission: $locationPermission)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationControllerStateImpl &&
            (identical(other.locationPermission, locationPermission) ||
                other.locationPermission == locationPermission));
  }

  @override
  int get hashCode => Object.hash(runtimeType, locationPermission);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationControllerStateImplCopyWith<_$LocationControllerStateImpl>
      get copyWith => __$$LocationControllerStateImplCopyWithImpl<
          _$LocationControllerStateImpl>(this, _$identity);
}

abstract class _LocationControllerState implements LocationControllerState {
  const factory _LocationControllerState(
          {final PermissionStatus? locationPermission}) =
      _$LocationControllerStateImpl;

  @override
  PermissionStatus? get locationPermission;
  @override
  @JsonKey(ignore: true)
  _$$LocationControllerStateImplCopyWith<_$LocationControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
