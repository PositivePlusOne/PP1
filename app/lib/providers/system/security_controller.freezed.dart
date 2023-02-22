// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SecurityControllerState {
  bool get canAuthenticateWithBiometricsLocally =>
      throw _privateConstructorUsedError;
  bool get canAuthenticateLocally => throw _privateConstructorUsedError;
  List<BiometricType> get biometricTypes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SecurityControllerStateCopyWith<SecurityControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityControllerStateCopyWith<$Res> {
  factory $SecurityControllerStateCopyWith(SecurityControllerState value,
          $Res Function(SecurityControllerState) then) =
      _$SecurityControllerStateCopyWithImpl<$Res, SecurityControllerState>;
  @useResult
  $Res call(
      {bool canAuthenticateWithBiometricsLocally,
      bool canAuthenticateLocally,
      List<BiometricType> biometricTypes});
}

/// @nodoc
class _$SecurityControllerStateCopyWithImpl<$Res,
        $Val extends SecurityControllerState>
    implements $SecurityControllerStateCopyWith<$Res> {
  _$SecurityControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canAuthenticateWithBiometricsLocally = null,
    Object? canAuthenticateLocally = null,
    Object? biometricTypes = null,
  }) {
    return _then(_value.copyWith(
      canAuthenticateWithBiometricsLocally: null ==
              canAuthenticateWithBiometricsLocally
          ? _value.canAuthenticateWithBiometricsLocally
          : canAuthenticateWithBiometricsLocally // ignore: cast_nullable_to_non_nullable
              as bool,
      canAuthenticateLocally: null == canAuthenticateLocally
          ? _value.canAuthenticateLocally
          : canAuthenticateLocally // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricTypes: null == biometricTypes
          ? _value.biometricTypes
          : biometricTypes // ignore: cast_nullable_to_non_nullable
              as List<BiometricType>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SecurityControllerStateCopyWith<$Res>
    implements $SecurityControllerStateCopyWith<$Res> {
  factory _$$_SecurityControllerStateCopyWith(_$_SecurityControllerState value,
          $Res Function(_$_SecurityControllerState) then) =
      __$$_SecurityControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool canAuthenticateWithBiometricsLocally,
      bool canAuthenticateLocally,
      List<BiometricType> biometricTypes});
}

/// @nodoc
class __$$_SecurityControllerStateCopyWithImpl<$Res>
    extends _$SecurityControllerStateCopyWithImpl<$Res,
        _$_SecurityControllerState>
    implements _$$_SecurityControllerStateCopyWith<$Res> {
  __$$_SecurityControllerStateCopyWithImpl(_$_SecurityControllerState _value,
      $Res Function(_$_SecurityControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canAuthenticateWithBiometricsLocally = null,
    Object? canAuthenticateLocally = null,
    Object? biometricTypes = null,
  }) {
    return _then(_$_SecurityControllerState(
      canAuthenticateWithBiometricsLocally: null ==
              canAuthenticateWithBiometricsLocally
          ? _value.canAuthenticateWithBiometricsLocally
          : canAuthenticateWithBiometricsLocally // ignore: cast_nullable_to_non_nullable
              as bool,
      canAuthenticateLocally: null == canAuthenticateLocally
          ? _value.canAuthenticateLocally
          : canAuthenticateLocally // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricTypes: null == biometricTypes
          ? _value._biometricTypes
          : biometricTypes // ignore: cast_nullable_to_non_nullable
              as List<BiometricType>,
    ));
  }
}

/// @nodoc

class _$_SecurityControllerState implements _SecurityControllerState {
  const _$_SecurityControllerState(
      {this.canAuthenticateWithBiometricsLocally = false,
      this.canAuthenticateLocally = false,
      final List<BiometricType> biometricTypes = const []})
      : _biometricTypes = biometricTypes;

  @override
  @JsonKey()
  final bool canAuthenticateWithBiometricsLocally;
  @override
  @JsonKey()
  final bool canAuthenticateLocally;
  final List<BiometricType> _biometricTypes;
  @override
  @JsonKey()
  List<BiometricType> get biometricTypes {
    if (_biometricTypes is EqualUnmodifiableListView) return _biometricTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_biometricTypes);
  }

  @override
  String toString() {
    return 'SecurityControllerState(canAuthenticateWithBiometricsLocally: $canAuthenticateWithBiometricsLocally, canAuthenticateLocally: $canAuthenticateLocally, biometricTypes: $biometricTypes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SecurityControllerState &&
            (identical(other.canAuthenticateWithBiometricsLocally,
                    canAuthenticateWithBiometricsLocally) ||
                other.canAuthenticateWithBiometricsLocally ==
                    canAuthenticateWithBiometricsLocally) &&
            (identical(other.canAuthenticateLocally, canAuthenticateLocally) ||
                other.canAuthenticateLocally == canAuthenticateLocally) &&
            const DeepCollectionEquality()
                .equals(other._biometricTypes, _biometricTypes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      canAuthenticateWithBiometricsLocally,
      canAuthenticateLocally,
      const DeepCollectionEquality().hash(_biometricTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SecurityControllerStateCopyWith<_$_SecurityControllerState>
      get copyWith =>
          __$$_SecurityControllerStateCopyWithImpl<_$_SecurityControllerState>(
              this, _$identity);
}

abstract class _SecurityControllerState implements SecurityControllerState {
  const factory _SecurityControllerState(
      {final bool canAuthenticateWithBiometricsLocally,
      final bool canAuthenticateLocally,
      final List<BiometricType> biometricTypes}) = _$_SecurityControllerState;

  @override
  bool get canAuthenticateWithBiometricsLocally;
  @override
  bool get canAuthenticateLocally;
  @override
  List<BiometricType> get biometricTypes;
  @override
  @JsonKey(ignore: true)
  _$$_SecurityControllerStateCopyWith<_$_SecurityControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
