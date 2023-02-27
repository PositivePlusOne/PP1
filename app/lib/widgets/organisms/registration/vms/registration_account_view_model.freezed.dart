// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_account_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationAccountViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationAccountViewModelStateCopyWith<RegistrationAccountViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationAccountViewModelStateCopyWith<$Res> {
  factory $RegistrationAccountViewModelStateCopyWith(
          RegistrationAccountViewModelState value,
          $Res Function(RegistrationAccountViewModelState) then) =
      _$RegistrationAccountViewModelStateCopyWithImpl<$Res,
          RegistrationAccountViewModelState>;
  @useResult
  $Res call({bool isBusy, Object? currentError});
}

/// @nodoc
class _$RegistrationAccountViewModelStateCopyWithImpl<$Res,
        $Val extends RegistrationAccountViewModelState>
    implements $RegistrationAccountViewModelStateCopyWith<$Res> {
  _$RegistrationAccountViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_RegistrationAccountViewModelStateCopyWith<$Res>
    implements $RegistrationAccountViewModelStateCopyWith<$Res> {
  factory _$$_RegistrationAccountViewModelStateCopyWith(
          _$_RegistrationAccountViewModelState value,
          $Res Function(_$_RegistrationAccountViewModelState) then) =
      __$$_RegistrationAccountViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, Object? currentError});
}

/// @nodoc
class __$$_RegistrationAccountViewModelStateCopyWithImpl<$Res>
    extends _$RegistrationAccountViewModelStateCopyWithImpl<$Res,
        _$_RegistrationAccountViewModelState>
    implements _$$_RegistrationAccountViewModelStateCopyWith<$Res> {
  __$$_RegistrationAccountViewModelStateCopyWithImpl(
      _$_RegistrationAccountViewModelState _value,
      $Res Function(_$_RegistrationAccountViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? currentError = freezed,
  }) {
    return _then(_$_RegistrationAccountViewModelState(
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

class _$_RegistrationAccountViewModelState
    implements _RegistrationAccountViewModelState {
  const _$_RegistrationAccountViewModelState(
      {this.isBusy = false, this.currentError});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final Object? currentError;

  @override
  String toString() {
    return 'RegistrationAccountViewModelState(isBusy: $isBusy, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationAccountViewModelState &&
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
  _$$_RegistrationAccountViewModelStateCopyWith<
          _$_RegistrationAccountViewModelState>
      get copyWith => __$$_RegistrationAccountViewModelStateCopyWithImpl<
          _$_RegistrationAccountViewModelState>(this, _$identity);
}

abstract class _RegistrationAccountViewModelState
    implements RegistrationAccountViewModelState {
  const factory _RegistrationAccountViewModelState(
      {final bool isBusy,
      final Object? currentError}) = _$_RegistrationAccountViewModelState;

  @override
  bool get isBusy;
  @override
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationAccountViewModelStateCopyWith<
          _$_RegistrationAccountViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
