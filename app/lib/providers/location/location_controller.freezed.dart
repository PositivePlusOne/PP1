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
abstract class _$$_LocationOptionCopyWith<$Res>
    implements $LocationOptionCopyWith<$Res> {
  factory _$$_LocationOptionCopyWith(
          _$_LocationOption value, $Res Function(_$_LocationOption) then) =
      __$$_LocationOptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String placeId});
}

/// @nodoc
class __$$_LocationOptionCopyWithImpl<$Res>
    extends _$LocationOptionCopyWithImpl<$Res, _$_LocationOption>
    implements _$$_LocationOptionCopyWith<$Res> {
  __$$_LocationOptionCopyWithImpl(
      _$_LocationOption _value, $Res Function(_$_LocationOption) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
  }) {
    return _then(_$_LocationOption(
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

class _$_LocationOption implements _LocationOption {
  const _$_LocationOption({required this.description, required this.placeId});

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
            other is _$_LocationOption &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, placeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocationOptionCopyWith<_$_LocationOption> get copyWith =>
      __$$_LocationOptionCopyWithImpl<_$_LocationOption>(this, _$identity);
}

abstract class _LocationOption implements LocationOption {
  const factory _LocationOption(
      {required final String description,
      required final String placeId}) = _$_LocationOption;

  @override
  String get description;
  @override
  String get placeId;
  @override
  @JsonKey(ignore: true)
  _$$_LocationOptionCopyWith<_$_LocationOption> get copyWith =>
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
abstract class _$$_LocationControllerStateCopyWith<$Res>
    implements $LocationControllerStateCopyWith<$Res> {
  factory _$$_LocationControllerStateCopyWith(_$_LocationControllerState value,
          $Res Function(_$_LocationControllerState) then) =
      __$$_LocationControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PermissionStatus? locationPermission});
}

/// @nodoc
class __$$_LocationControllerStateCopyWithImpl<$Res>
    extends _$LocationControllerStateCopyWithImpl<$Res,
        _$_LocationControllerState>
    implements _$$_LocationControllerStateCopyWith<$Res> {
  __$$_LocationControllerStateCopyWithImpl(_$_LocationControllerState _value,
      $Res Function(_$_LocationControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationPermission = freezed,
  }) {
    return _then(_$_LocationControllerState(
      locationPermission: freezed == locationPermission
          ? _value.locationPermission
          : locationPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
    ));
  }
}

/// @nodoc

class _$_LocationControllerState implements _LocationControllerState {
  const _$_LocationControllerState({this.locationPermission});

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
            other is _$_LocationControllerState &&
            (identical(other.locationPermission, locationPermission) ||
                other.locationPermission == locationPermission));
  }

  @override
  int get hashCode => Object.hash(runtimeType, locationPermission);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocationControllerStateCopyWith<_$_LocationControllerState>
      get copyWith =>
          __$$_LocationControllerStateCopyWithImpl<_$_LocationControllerState>(
              this, _$identity);
}

abstract class _LocationControllerState implements LocationControllerState {
  const factory _LocationControllerState(
          {final PermissionStatus? locationPermission}) =
      _$_LocationControllerState;

  @override
  PermissionStatus? get locationPermission;
  @override
  @JsonKey(ignore: true)
  _$$_LocationControllerStateCopyWith<_$_LocationControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
