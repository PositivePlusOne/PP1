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
  bool get canCheckBiometrics => throw _privateConstructorUsedError;
  bool get hasBiometrics => throw _privateConstructorUsedError;
  List<BiometricType> get biometricDevices =>
      throw _privateConstructorUsedError;

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
      {bool canCheckBiometrics,
      bool hasBiometrics,
      List<BiometricType> biometricDevices});
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
    Object? canCheckBiometrics = null,
    Object? hasBiometrics = null,
    Object? biometricDevices = null,
  }) {
    return _then(_value.copyWith(
      canCheckBiometrics: null == canCheckBiometrics
          ? _value.canCheckBiometrics
          : canCheckBiometrics // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBiometrics: null == hasBiometrics
          ? _value.hasBiometrics
          : hasBiometrics // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricDevices: null == biometricDevices
          ? _value.biometricDevices
          : biometricDevices // ignore: cast_nullable_to_non_nullable
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
      {bool canCheckBiometrics,
      bool hasBiometrics,
      List<BiometricType> biometricDevices});
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
    Object? canCheckBiometrics = null,
    Object? hasBiometrics = null,
    Object? biometricDevices = null,
  }) {
    return _then(_$_SecurityControllerState(
      canCheckBiometrics: null == canCheckBiometrics
          ? _value.canCheckBiometrics
          : canCheckBiometrics // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBiometrics: null == hasBiometrics
          ? _value.hasBiometrics
          : hasBiometrics // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricDevices: null == biometricDevices
          ? _value._biometricDevices
          : biometricDevices // ignore: cast_nullable_to_non_nullable
              as List<BiometricType>,
    ));
  }
}

/// @nodoc

class _$_SecurityControllerState implements _SecurityControllerState {
  const _$_SecurityControllerState(
      {this.canCheckBiometrics = false,
      this.hasBiometrics = false,
      final List<BiometricType> biometricDevices = const []})
      : _biometricDevices = biometricDevices;

  @override
  @JsonKey()
  final bool canCheckBiometrics;
  @override
  @JsonKey()
  final bool hasBiometrics;
  final List<BiometricType> _biometricDevices;
  @override
  @JsonKey()
  List<BiometricType> get biometricDevices {
    if (_biometricDevices is EqualUnmodifiableListView)
      return _biometricDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_biometricDevices);
  }

  @override
  String toString() {
    return 'SecurityControllerState(canCheckBiometrics: $canCheckBiometrics, hasBiometrics: $hasBiometrics, biometricDevices: $biometricDevices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SecurityControllerState &&
            (identical(other.canCheckBiometrics, canCheckBiometrics) ||
                other.canCheckBiometrics == canCheckBiometrics) &&
            (identical(other.hasBiometrics, hasBiometrics) ||
                other.hasBiometrics == hasBiometrics) &&
            const DeepCollectionEquality()
                .equals(other._biometricDevices, _biometricDevices));
  }

  @override
  int get hashCode => Object.hash(runtimeType, canCheckBiometrics,
      hasBiometrics, const DeepCollectionEquality().hash(_biometricDevices));

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
      {final bool canCheckBiometrics,
      final bool hasBiometrics,
      final List<BiometricType> biometricDevices}) = _$_SecurityControllerState;

  @override
  bool get canCheckBiometrics;
  @override
  bool get hasBiometrics;
  @override
  List<BiometricType> get biometricDevices;
  @override
  @JsonKey(ignore: true)
  _$$_SecurityControllerStateCopyWith<_$_SecurityControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
