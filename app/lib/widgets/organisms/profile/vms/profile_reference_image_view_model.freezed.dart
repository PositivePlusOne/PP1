// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_reference_image_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileReferenceImageViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  FaceDetectionModel? get faceDetectionModel =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileReferenceImageViewModelStateCopyWith<
          ProfileReferenceImageViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileReferenceImageViewModelStateCopyWith<$Res> {
  factory $ProfileReferenceImageViewModelStateCopyWith(
          ProfileReferenceImageViewModelState value,
          $Res Function(ProfileReferenceImageViewModelState) then) =
      _$ProfileReferenceImageViewModelStateCopyWithImpl<$Res,
          ProfileReferenceImageViewModelState>;
  @useResult
  $Res call({bool isBusy, FaceDetectionModel? faceDetectionModel});

  $FaceDetectionModelCopyWith<$Res>? get faceDetectionModel;
}

/// @nodoc
class _$ProfileReferenceImageViewModelStateCopyWithImpl<$Res,
        $Val extends ProfileReferenceImageViewModelState>
    implements $ProfileReferenceImageViewModelStateCopyWith<$Res> {
  _$ProfileReferenceImageViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? faceDetectionModel = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      faceDetectionModel: freezed == faceDetectionModel
          ? _value.faceDetectionModel
          : faceDetectionModel // ignore: cast_nullable_to_non_nullable
              as FaceDetectionModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FaceDetectionModelCopyWith<$Res>? get faceDetectionModel {
    if (_value.faceDetectionModel == null) {
      return null;
    }

    return $FaceDetectionModelCopyWith<$Res>(_value.faceDetectionModel!,
        (value) {
      return _then(_value.copyWith(faceDetectionModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileReferenceImageViewModelStateImplCopyWith<$Res>
    implements $ProfileReferenceImageViewModelStateCopyWith<$Res> {
  factory _$$ProfileReferenceImageViewModelStateImplCopyWith(
          _$ProfileReferenceImageViewModelStateImpl value,
          $Res Function(_$ProfileReferenceImageViewModelStateImpl) then) =
      __$$ProfileReferenceImageViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, FaceDetectionModel? faceDetectionModel});

  @override
  $FaceDetectionModelCopyWith<$Res>? get faceDetectionModel;
}

/// @nodoc
class __$$ProfileReferenceImageViewModelStateImplCopyWithImpl<$Res>
    extends _$ProfileReferenceImageViewModelStateCopyWithImpl<$Res,
        _$ProfileReferenceImageViewModelStateImpl>
    implements _$$ProfileReferenceImageViewModelStateImplCopyWith<$Res> {
  __$$ProfileReferenceImageViewModelStateImplCopyWithImpl(
      _$ProfileReferenceImageViewModelStateImpl _value,
      $Res Function(_$ProfileReferenceImageViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? faceDetectionModel = freezed,
  }) {
    return _then(_$ProfileReferenceImageViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      faceDetectionModel: freezed == faceDetectionModel
          ? _value.faceDetectionModel
          : faceDetectionModel // ignore: cast_nullable_to_non_nullable
              as FaceDetectionModel?,
    ));
  }
}

/// @nodoc

class _$ProfileReferenceImageViewModelStateImpl
    implements _ProfileReferenceImageViewModelState {
  const _$ProfileReferenceImageViewModelStateImpl(
      {this.isBusy = false, this.faceDetectionModel});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final FaceDetectionModel? faceDetectionModel;

  @override
  String toString() {
    return 'ProfileReferenceImageViewModelState(isBusy: $isBusy, faceDetectionModel: $faceDetectionModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileReferenceImageViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.faceDetectionModel, faceDetectionModel) ||
                other.faceDetectionModel == faceDetectionModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy, faceDetectionModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileReferenceImageViewModelStateImplCopyWith<
          _$ProfileReferenceImageViewModelStateImpl>
      get copyWith => __$$ProfileReferenceImageViewModelStateImplCopyWithImpl<
          _$ProfileReferenceImageViewModelStateImpl>(this, _$identity);
}

abstract class _ProfileReferenceImageViewModelState
    implements ProfileReferenceImageViewModelState {
  const factory _ProfileReferenceImageViewModelState(
          {final bool isBusy, final FaceDetectionModel? faceDetectionModel}) =
      _$ProfileReferenceImageViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  FaceDetectionModel? get faceDetectionModel;
  @override
  @JsonKey(ignore: true)
  _$$ProfileReferenceImageViewModelStateImplCopyWith<
          _$ProfileReferenceImageViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
