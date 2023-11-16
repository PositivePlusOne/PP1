// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserControllerState {
  DateTime get last2FACheck => throw _privateConstructorUsedError;
  Map<String, dynamic> get currentClaims => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserControllerStateCopyWith<UserControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserControllerStateCopyWith<$Res> {
  factory $UserControllerStateCopyWith(
          UserControllerState value, $Res Function(UserControllerState) then) =
      _$UserControllerStateCopyWithImpl<$Res, UserControllerState>;
  @useResult
  $Res call({DateTime last2FACheck, Map<String, dynamic> currentClaims});
}

/// @nodoc
class _$UserControllerStateCopyWithImpl<$Res, $Val extends UserControllerState>
    implements $UserControllerStateCopyWith<$Res> {
  _$UserControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last2FACheck = null,
    Object? currentClaims = null,
  }) {
    return _then(_value.copyWith(
      last2FACheck: null == last2FACheck
          ? _value.last2FACheck
          : last2FACheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentClaims: null == currentClaims
          ? _value.currentClaims
          : currentClaims // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserControllerStateImplCopyWith<$Res>
    implements $UserControllerStateCopyWith<$Res> {
  factory _$$UserControllerStateImplCopyWith(_$UserControllerStateImpl value,
          $Res Function(_$UserControllerStateImpl) then) =
      __$$UserControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime last2FACheck, Map<String, dynamic> currentClaims});
}

/// @nodoc
class __$$UserControllerStateImplCopyWithImpl<$Res>
    extends _$UserControllerStateCopyWithImpl<$Res, _$UserControllerStateImpl>
    implements _$$UserControllerStateImplCopyWith<$Res> {
  __$$UserControllerStateImplCopyWithImpl(_$UserControllerStateImpl _value,
      $Res Function(_$UserControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last2FACheck = null,
    Object? currentClaims = null,
  }) {
    return _then(_$UserControllerStateImpl(
      last2FACheck: null == last2FACheck
          ? _value.last2FACheck
          : last2FACheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentClaims: null == currentClaims
          ? _value._currentClaims
          : currentClaims // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$UserControllerStateImpl implements _UserControllerState {
  const _$UserControllerStateImpl(
      {required this.last2FACheck,
      final Map<String, dynamic> currentClaims = const {}})
      : _currentClaims = currentClaims;

  @override
  final DateTime last2FACheck;
  final Map<String, dynamic> _currentClaims;
  @override
  @JsonKey()
  Map<String, dynamic> get currentClaims {
    if (_currentClaims is EqualUnmodifiableMapView) return _currentClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentClaims);
  }

  @override
  String toString() {
    return 'UserControllerState(last2FACheck: $last2FACheck, currentClaims: $currentClaims)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserControllerStateImpl &&
            (identical(other.last2FACheck, last2FACheck) ||
                other.last2FACheck == last2FACheck) &&
            const DeepCollectionEquality()
                .equals(other._currentClaims, _currentClaims));
  }

  @override
  int get hashCode => Object.hash(runtimeType, last2FACheck,
      const DeepCollectionEquality().hash(_currentClaims));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserControllerStateImplCopyWith<_$UserControllerStateImpl> get copyWith =>
      __$$UserControllerStateImplCopyWithImpl<_$UserControllerStateImpl>(
          this, _$identity);
}

abstract class _UserControllerState implements UserControllerState {
  const factory _UserControllerState(
      {required final DateTime last2FACheck,
      final Map<String, dynamic> currentClaims}) = _$UserControllerStateImpl;

  @override
  DateTime get last2FACheck;
  @override
  Map<String, dynamic> get currentClaims;
  @override
  @JsonKey(ignore: true)
  _$$UserControllerStateImplCopyWith<_$UserControllerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
