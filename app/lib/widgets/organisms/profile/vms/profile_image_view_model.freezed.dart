// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_image_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileImageViewModelState {
  bool get isBusy =>
      throw _privateConstructorUsedError; //? has a face been found
  bool get faceFound =>
      throw _privateConstructorUsedError; //? camera has been started and is available for interactions
  bool get cameraControllerInitialised =>
      throw _privateConstructorUsedError; //? The current error to be shown to the user
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileImageViewModelStateCopyWith<ProfileImageViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileImageViewModelStateCopyWith<$Res> {
  factory $ProfileImageViewModelStateCopyWith(ProfileImageViewModelState value,
          $Res Function(ProfileImageViewModelState) then) =
      _$ProfileImageViewModelStateCopyWithImpl<$Res,
          ProfileImageViewModelState>;
  @useResult
  $Res call(
      {bool isBusy,
      bool faceFound,
      bool cameraControllerInitialised,
      Object? currentError});
}

/// @nodoc
class _$ProfileImageViewModelStateCopyWithImpl<$Res,
        $Val extends ProfileImageViewModelState>
    implements $ProfileImageViewModelStateCopyWith<$Res> {
  _$ProfileImageViewModelStateCopyWithImpl(this._value, this._then);

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
    Object? currentError = freezed,
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
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileImageViewModelStateCopyWith<$Res>
    implements $ProfileImageViewModelStateCopyWith<$Res> {
  factory _$$_ProfileImageViewModelStateCopyWith(
          _$_ProfileImageViewModelState value,
          $Res Function(_$_ProfileImageViewModelState) then) =
      __$$_ProfileImageViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      bool faceFound,
      bool cameraControllerInitialised,
      Object? currentError});
}

/// @nodoc
class __$$_ProfileImageViewModelStateCopyWithImpl<$Res>
    extends _$ProfileImageViewModelStateCopyWithImpl<$Res,
        _$_ProfileImageViewModelState>
    implements _$$_ProfileImageViewModelStateCopyWith<$Res> {
  __$$_ProfileImageViewModelStateCopyWithImpl(
      _$_ProfileImageViewModelState _value,
      $Res Function(_$_ProfileImageViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? faceFound = null,
    Object? cameraControllerInitialised = null,
    Object? currentError = freezed,
  }) {
    return _then(_$_ProfileImageViewModelState(
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
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ));
  }
}

/// @nodoc

class _$_ProfileImageViewModelState implements _ProfileImageViewModelState {
  const _$_ProfileImageViewModelState(
      {this.isBusy = false,
      this.faceFound = false,
      this.cameraControllerInitialised = false,
      this.currentError});

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
//? The current error to be shown to the user
  @override
  final Object? currentError;

  @override
  String toString() {
    return 'ProfileImageViewModelState(isBusy: $isBusy, faceFound: $faceFound, cameraControllerInitialised: $cameraControllerInitialised, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileImageViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.faceFound, faceFound) ||
                other.faceFound == faceFound) &&
            (identical(other.cameraControllerInitialised,
                    cameraControllerInitialised) ||
                other.cameraControllerInitialised ==
                    cameraControllerInitialised) &&
            const DeepCollectionEquality()
                .equals(other.currentError, currentError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isBusy,
      faceFound,
      cameraControllerInitialised,
      const DeepCollectionEquality().hash(currentError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileImageViewModelStateCopyWith<_$_ProfileImageViewModelState>
      get copyWith => __$$_ProfileImageViewModelStateCopyWithImpl<
          _$_ProfileImageViewModelState>(this, _$identity);
}

abstract class _ProfileImageViewModelState
    implements ProfileImageViewModelState {
  const factory _ProfileImageViewModelState(
      {final bool isBusy,
      final bool faceFound,
      final bool cameraControllerInitialised,
      final Object? currentError}) = _$_ProfileImageViewModelState;

  @override
  bool get isBusy;
  @override //? has a face been found
  bool get faceFound;
  @override //? camera has been started and is available for interactions
  bool get cameraControllerInitialised;
  @override //? The current error to be shown to the user
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileImageViewModelStateCopyWith<_$_ProfileImageViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
