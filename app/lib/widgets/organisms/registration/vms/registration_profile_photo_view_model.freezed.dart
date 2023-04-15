// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_profile_photo_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationProfilePhotoViewModelState {
  bool get isBusy =>
      throw _privateConstructorUsedError; //? camera has been started and is available for interactions
  bool get cameraControllerInitialised => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationProfilePhotoViewModelStateCopyWith<
          RegistrationProfilePhotoViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationProfilePhotoViewModelStateCopyWith<$Res> {
  factory $RegistrationProfilePhotoViewModelStateCopyWith(
          RegistrationProfilePhotoViewModelState value,
          $Res Function(RegistrationProfilePhotoViewModelState) then) =
      _$RegistrationProfilePhotoViewModelStateCopyWithImpl<$Res,
          RegistrationProfilePhotoViewModelState>;
  @useResult
  $Res call({bool isBusy, bool cameraControllerInitialised});
}

/// @nodoc
class _$RegistrationProfilePhotoViewModelStateCopyWithImpl<$Res,
        $Val extends RegistrationProfilePhotoViewModelState>
    implements $RegistrationProfilePhotoViewModelStateCopyWith<$Res> {
  _$RegistrationProfilePhotoViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? cameraControllerInitialised = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraControllerInitialised: null == cameraControllerInitialised
          ? _value.cameraControllerInitialised
          : cameraControllerInitialised // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegistrationProfilePhotoViewModelStateCopyWith<$Res>
    implements $RegistrationProfilePhotoViewModelStateCopyWith<$Res> {
  factory _$$_RegistrationProfilePhotoViewModelStateCopyWith(
          _$_RegistrationProfilePhotoViewModelState value,
          $Res Function(_$_RegistrationProfilePhotoViewModelState) then) =
      __$$_RegistrationProfilePhotoViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, bool cameraControllerInitialised});
}

/// @nodoc
class __$$_RegistrationProfilePhotoViewModelStateCopyWithImpl<$Res>
    extends _$RegistrationProfilePhotoViewModelStateCopyWithImpl<$Res,
        _$_RegistrationProfilePhotoViewModelState>
    implements _$$_RegistrationProfilePhotoViewModelStateCopyWith<$Res> {
  __$$_RegistrationProfilePhotoViewModelStateCopyWithImpl(
      _$_RegistrationProfilePhotoViewModelState _value,
      $Res Function(_$_RegistrationProfilePhotoViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? cameraControllerInitialised = null,
  }) {
    return _then(_$_RegistrationProfilePhotoViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraControllerInitialised: null == cameraControllerInitialised
          ? _value.cameraControllerInitialised
          : cameraControllerInitialised // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RegistrationProfilePhotoViewModelState
    implements _RegistrationProfilePhotoViewModelState {
  const _$_RegistrationProfilePhotoViewModelState(
      {this.isBusy = false, this.cameraControllerInitialised = false});

  @override
  @JsonKey()
  final bool isBusy;
//? camera has been started and is available for interactions
  @override
  @JsonKey()
  final bool cameraControllerInitialised;

  @override
  String toString() {
    return 'RegistrationProfilePhotoViewModelState(isBusy: $isBusy, cameraControllerInitialised: $cameraControllerInitialised)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationProfilePhotoViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.cameraControllerInitialised,
                    cameraControllerInitialised) ||
                other.cameraControllerInitialised ==
                    cameraControllerInitialised));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isBusy, cameraControllerInitialised);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegistrationProfilePhotoViewModelStateCopyWith<
          _$_RegistrationProfilePhotoViewModelState>
      get copyWith => __$$_RegistrationProfilePhotoViewModelStateCopyWithImpl<
          _$_RegistrationProfilePhotoViewModelState>(this, _$identity);
}

abstract class _RegistrationProfilePhotoViewModelState
    implements RegistrationProfilePhotoViewModelState {
  const factory _RegistrationProfilePhotoViewModelState(
          {final bool isBusy, final bool cameraControllerInitialised}) =
      _$_RegistrationProfilePhotoViewModelState;

  @override
  bool get isBusy;
  @override //? camera has been started and is available for interactions
  bool get cameraControllerInitialised;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationProfilePhotoViewModelStateCopyWith<
          _$_RegistrationProfilePhotoViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
