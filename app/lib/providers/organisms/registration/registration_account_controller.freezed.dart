// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_account_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationAccountControllerState {
  bool get isBusy => throw _privateConstructorUsedError;
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationAccountControllerStateCopyWith<
          RegistrationAccountControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationAccountControllerStateCopyWith<$Res> {
  factory $RegistrationAccountControllerStateCopyWith(
          RegistrationAccountControllerState value,
          $Res Function(RegistrationAccountControllerState) then) =
      _$RegistrationAccountControllerStateCopyWithImpl<$Res,
          RegistrationAccountControllerState>;
  @useResult
  $Res call({bool isBusy, Object? currentError});
}

/// @nodoc
class _$RegistrationAccountControllerStateCopyWithImpl<$Res,
        $Val extends RegistrationAccountControllerState>
    implements $RegistrationAccountControllerStateCopyWith<$Res> {
  _$RegistrationAccountControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? currentError = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegistrationAccountControllerStateCopyWith<$Res>
    implements $RegistrationAccountControllerStateCopyWith<$Res> {
  factory _$$_RegistrationAccountControllerStateCopyWith(
          _$_RegistrationAccountControllerState value,
          $Res Function(_$_RegistrationAccountControllerState) then) =
      __$$_RegistrationAccountControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, Object? currentError});
}

/// @nodoc
class __$$_RegistrationAccountControllerStateCopyWithImpl<$Res>
    extends _$RegistrationAccountControllerStateCopyWithImpl<$Res,
        _$_RegistrationAccountControllerState>
    implements _$$_RegistrationAccountControllerStateCopyWith<$Res> {
  __$$_RegistrationAccountControllerStateCopyWithImpl(
      _$_RegistrationAccountControllerState _value,
      $Res Function(_$_RegistrationAccountControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? currentError = freezed,
  }) {
    return _then(_$_RegistrationAccountControllerState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ));
  }
}

/// @nodoc

class _$_RegistrationAccountControllerState
    implements _RegistrationAccountControllerState {
  const _$_RegistrationAccountControllerState(
      {this.isBusy = false, this.currentError});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final Object? currentError;

  @override
  String toString() {
    return 'RegistrationAccountControllerState(isBusy: $isBusy, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationAccountControllerState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            const DeepCollectionEquality()
                .equals(other.currentError, currentError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isBusy, const DeepCollectionEquality().hash(currentError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegistrationAccountControllerStateCopyWith<
          _$_RegistrationAccountControllerState>
      get copyWith => __$$_RegistrationAccountControllerStateCopyWithImpl<
          _$_RegistrationAccountControllerState>(this, _$identity);
}

abstract class _RegistrationAccountControllerState
    implements RegistrationAccountControllerState {
  const factory _RegistrationAccountControllerState(
      {final bool isBusy,
      final Object? currentError}) = _$_RegistrationAccountControllerState;

  @override
  bool get isBusy;
  @override
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationAccountControllerStateCopyWith<
          _$_RegistrationAccountControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
