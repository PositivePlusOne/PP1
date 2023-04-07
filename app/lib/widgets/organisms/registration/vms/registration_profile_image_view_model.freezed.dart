// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_profile_image_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationProfileImageViewModelState {
  bool get isBusy =>
      throw _privateConstructorUsedError; //? has a face been found
  bool get faceFound =>
      throw _privateConstructorUsedError; //? camera has been started and is available for interactions
  bool get cameraControllerInitialised => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationProfileImageViewModelStateCopyWith<
          RegistrationProfileImageViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationProfileImageViewModelStateCopyWith<$Res> {
  factory $RegistrationProfileImageViewModelStateCopyWith(
          RegistrationProfileImageViewModelState value,
          $Res Function(RegistrationProfileImageViewModelState) then) =
      _$RegistrationProfileImageViewModelStateCopyWithImpl<$Res,
          RegistrationProfileImageViewModelState>;
  @useResult
  $Res call({bool isBusy, bool faceFound, bool cameraControllerInitialised});
}

/// @nodoc
class _$RegistrationProfileImageViewModelStateCopyWithImpl<$Res,
        $Val extends RegistrationProfileImageViewModelState>
    implements $RegistrationProfileImageViewModelStateCopyWith<$Res> {
  _$RegistrationProfileImageViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? faceFound = null,
    Object? cameraControllerInitialised = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      faceFound: null == faceFound
          ? _value.faceFound
          : faceFound // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraControllerInitialised: null == cameraControllerInitialised
          ? _value.cameraControllerInitialised
          : cameraControllerInitialised // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegistrationProfileImageViewModelStateCopyWith<$Res>
    implements $RegistrationProfileImageViewModelStateCopyWith<$Res> {
  factory _$$_RegistrationProfileImageViewModelStateCopyWith(
          _$_RegistrationProfileImageViewModelState value,
          $Res Function(_$_RegistrationProfileImageViewModelState) then) =
      __$$_RegistrationProfileImageViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, bool faceFound, bool cameraControllerInitialised});
}

/// @nodoc
class __$$_RegistrationProfileImageViewModelStateCopyWithImpl<$Res>
    extends _$RegistrationProfileImageViewModelStateCopyWithImpl<$Res,
        _$_RegistrationProfileImageViewModelState>
    implements _$$_RegistrationProfileImageViewModelStateCopyWith<$Res> {
  __$$_RegistrationProfileImageViewModelStateCopyWithImpl(
      _$_RegistrationProfileImageViewModelState _value,
      $Res Function(_$_RegistrationProfileImageViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? faceFound = null,
    Object? cameraControllerInitialised = null,
  }) {
    return _then(_$_RegistrationProfileImageViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      faceFound: null == faceFound
          ? _value.faceFound
          : faceFound // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraControllerInitialised: null == cameraControllerInitialised
          ? _value.cameraControllerInitialised
          : cameraControllerInitialised // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RegistrationProfileImageViewModelState
    implements _RegistrationProfileImageViewModelState {
  const _$_RegistrationProfileImageViewModelState(
      {this.isBusy = false,
      this.faceFound = false,
      this.cameraControllerInitialised = false});

  @override
  @JsonKey()
  final bool isBusy;
//? has a face been found
  @override
  @JsonKey()
  final bool faceFound;
//? camera has been started and is available for interactions
  @override
  @JsonKey()
  final bool cameraControllerInitialised;

  @override
  String toString() {
    return 'RegistrationProfileImageViewModelState(isBusy: $isBusy, faceFound: $faceFound, cameraControllerInitialised: $cameraControllerInitialised)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationProfileImageViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.faceFound, faceFound) ||
                other.faceFound == faceFound) &&
            (identical(other.cameraControllerInitialised,
                    cameraControllerInitialised) ||
                other.cameraControllerInitialised ==
                    cameraControllerInitialised));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isBusy, faceFound, cameraControllerInitialised);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegistrationProfileImageViewModelStateCopyWith<
          _$_RegistrationProfileImageViewModelState>
      get copyWith => __$$_RegistrationProfileImageViewModelStateCopyWithImpl<
          _$_RegistrationProfileImageViewModelState>(this, _$identity);
}

abstract class _RegistrationProfileImageViewModelState
    implements RegistrationProfileImageViewModelState {
  const factory _RegistrationProfileImageViewModelState(
          {final bool isBusy,
          final bool faceFound,
          final bool cameraControllerInitialised}) =
      _$_RegistrationProfileImageViewModelState;

  @override
  bool get isBusy;
  @override //? has a face been found
  bool get faceFound;
  @override //? camera has been started and is available for interactions
  bool get cameraControllerInitialised;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationProfileImageViewModelStateCopyWith<
          _$_RegistrationProfileImageViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
