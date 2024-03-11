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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegistrationAccountViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

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
  $Res call({bool isBusy});
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
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationAccountViewModelStateImplCopyWith<$Res>
    implements $RegistrationAccountViewModelStateCopyWith<$Res> {
  factory _$$RegistrationAccountViewModelStateImplCopyWith(
          _$RegistrationAccountViewModelStateImpl value,
          $Res Function(_$RegistrationAccountViewModelStateImpl) then) =
      __$$RegistrationAccountViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$RegistrationAccountViewModelStateImplCopyWithImpl<$Res>
    extends _$RegistrationAccountViewModelStateCopyWithImpl<$Res,
        _$RegistrationAccountViewModelStateImpl>
    implements _$$RegistrationAccountViewModelStateImplCopyWith<$Res> {
  __$$RegistrationAccountViewModelStateImplCopyWithImpl(
      _$RegistrationAccountViewModelStateImpl _value,
      $Res Function(_$RegistrationAccountViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$RegistrationAccountViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RegistrationAccountViewModelStateImpl
    implements _RegistrationAccountViewModelState {
  const _$RegistrationAccountViewModelStateImpl({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'RegistrationAccountViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationAccountViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationAccountViewModelStateImplCopyWith<
          _$RegistrationAccountViewModelStateImpl>
      get copyWith => __$$RegistrationAccountViewModelStateImplCopyWithImpl<
          _$RegistrationAccountViewModelStateImpl>(this, _$identity);
}

abstract class _RegistrationAccountViewModelState
    implements RegistrationAccountViewModelState {
  const factory _RegistrationAccountViewModelState({final bool isBusy}) =
      _$RegistrationAccountViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationAccountViewModelStateImplCopyWith<
          _$RegistrationAccountViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
