// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_detector_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FaceDetectionModel {
  List<Face> get faces => throw _privateConstructorUsedError;
  bool get isFacingCamera => throw _privateConstructorUsedError;
  bool get isInsideBoundingBox => throw _privateConstructorUsedError;
  Size get absoluteImageSize => throw _privateConstructorUsedError;
  InputImageRotation get imageRotation => throw _privateConstructorUsedError;
  Size get croppedSize => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FaceDetectionModelCopyWith<FaceDetectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FaceDetectionModelCopyWith<$Res> {
  factory $FaceDetectionModelCopyWith(
          FaceDetectionModel value, $Res Function(FaceDetectionModel) then) =
      _$FaceDetectionModelCopyWithImpl<$Res, FaceDetectionModel>;
  @useResult
  $Res call(
      {List<Face> faces,
      bool isFacingCamera,
      bool isInsideBoundingBox,
      Size absoluteImageSize,
      InputImageRotation imageRotation,
      Size croppedSize});
}

/// @nodoc
class _$FaceDetectionModelCopyWithImpl<$Res, $Val extends FaceDetectionModel>
    implements $FaceDetectionModelCopyWith<$Res> {
  _$FaceDetectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faces = null,
    Object? isFacingCamera = null,
    Object? isInsideBoundingBox = null,
    Object? absoluteImageSize = null,
    Object? imageRotation = null,
    Object? croppedSize = null,
  }) {
    return _then(_value.copyWith(
      faces: null == faces
          ? _value.faces
          : faces // ignore: cast_nullable_to_non_nullable
              as List<Face>,
      isFacingCamera: null == isFacingCamera
          ? _value.isFacingCamera
          : isFacingCamera // ignore: cast_nullable_to_non_nullable
              as bool,
      isInsideBoundingBox: null == isInsideBoundingBox
          ? _value.isInsideBoundingBox
          : isInsideBoundingBox // ignore: cast_nullable_to_non_nullable
              as bool,
      absoluteImageSize: null == absoluteImageSize
          ? _value.absoluteImageSize
          : absoluteImageSize // ignore: cast_nullable_to_non_nullable
              as Size,
      imageRotation: null == imageRotation
          ? _value.imageRotation
          : imageRotation // ignore: cast_nullable_to_non_nullable
              as InputImageRotation,
      croppedSize: null == croppedSize
          ? _value.croppedSize
          : croppedSize // ignore: cast_nullable_to_non_nullable
              as Size,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FaceDetectionModelCopyWith<$Res>
    implements $FaceDetectionModelCopyWith<$Res> {
  factory _$$_FaceDetectionModelCopyWith(_$_FaceDetectionModel value,
          $Res Function(_$_FaceDetectionModel) then) =
      __$$_FaceDetectionModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Face> faces,
      bool isFacingCamera,
      bool isInsideBoundingBox,
      Size absoluteImageSize,
      InputImageRotation imageRotation,
      Size croppedSize});
}

/// @nodoc
class __$$_FaceDetectionModelCopyWithImpl<$Res>
    extends _$FaceDetectionModelCopyWithImpl<$Res, _$_FaceDetectionModel>
    implements _$$_FaceDetectionModelCopyWith<$Res> {
  __$$_FaceDetectionModelCopyWithImpl(
      _$_FaceDetectionModel _value, $Res Function(_$_FaceDetectionModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faces = null,
    Object? isFacingCamera = null,
    Object? isInsideBoundingBox = null,
    Object? absoluteImageSize = null,
    Object? imageRotation = null,
    Object? croppedSize = null,
  }) {
    return _then(_$_FaceDetectionModel(
      faces: null == faces
          ? _value._faces
          : faces // ignore: cast_nullable_to_non_nullable
              as List<Face>,
      isFacingCamera: null == isFacingCamera
          ? _value.isFacingCamera
          : isFacingCamera // ignore: cast_nullable_to_non_nullable
              as bool,
      isInsideBoundingBox: null == isInsideBoundingBox
          ? _value.isInsideBoundingBox
          : isInsideBoundingBox // ignore: cast_nullable_to_non_nullable
              as bool,
      absoluteImageSize: null == absoluteImageSize
          ? _value.absoluteImageSize
          : absoluteImageSize // ignore: cast_nullable_to_non_nullable
              as Size,
      imageRotation: null == imageRotation
          ? _value.imageRotation
          : imageRotation // ignore: cast_nullable_to_non_nullable
              as InputImageRotation,
      croppedSize: null == croppedSize
          ? _value.croppedSize
          : croppedSize // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// @nodoc

class _$_FaceDetectionModel implements _FaceDetectionModel {
  const _$_FaceDetectionModel(
      {final List<Face> faces = const [],
      this.isFacingCamera = false,
      this.isInsideBoundingBox = false,
      this.absoluteImageSize = Size.zero,
      this.imageRotation = InputImageRotation.rotation0deg,
      this.croppedSize = Size.zero})
      : _faces = faces;

  final List<Face> _faces;
  @override
  @JsonKey()
  List<Face> get faces {
    if (_faces is EqualUnmodifiableListView) return _faces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_faces);
  }

  @override
  @JsonKey()
  final bool isFacingCamera;
  @override
  @JsonKey()
  final bool isInsideBoundingBox;
  @override
  @JsonKey()
  final Size absoluteImageSize;
  @override
  @JsonKey()
  final InputImageRotation imageRotation;
  @override
  @JsonKey()
  final Size croppedSize;

  @override
  String toString() {
    return 'FaceDetectionModel(faces: $faces, isFacingCamera: $isFacingCamera, isInsideBoundingBox: $isInsideBoundingBox, absoluteImageSize: $absoluteImageSize, imageRotation: $imageRotation, croppedSize: $croppedSize)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FaceDetectionModel &&
            const DeepCollectionEquality().equals(other._faces, _faces) &&
            (identical(other.isFacingCamera, isFacingCamera) ||
                other.isFacingCamera == isFacingCamera) &&
            (identical(other.isInsideBoundingBox, isInsideBoundingBox) ||
                other.isInsideBoundingBox == isInsideBoundingBox) &&
            (identical(other.absoluteImageSize, absoluteImageSize) ||
                other.absoluteImageSize == absoluteImageSize) &&
            (identical(other.imageRotation, imageRotation) ||
                other.imageRotation == imageRotation) &&
            (identical(other.croppedSize, croppedSize) ||
                other.croppedSize == croppedSize));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_faces),
      isFacingCamera,
      isInsideBoundingBox,
      absoluteImageSize,
      imageRotation,
      croppedSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FaceDetectionModelCopyWith<_$_FaceDetectionModel> get copyWith =>
      __$$_FaceDetectionModelCopyWithImpl<_$_FaceDetectionModel>(
          this, _$identity);
}

abstract class _FaceDetectionModel implements FaceDetectionModel {
  const factory _FaceDetectionModel(
      {final List<Face> faces,
      final bool isFacingCamera,
      final bool isInsideBoundingBox,
      final Size absoluteImageSize,
      final InputImageRotation imageRotation,
      final Size croppedSize}) = _$_FaceDetectionModel;

  @override
  List<Face> get faces;
  @override
  bool get isFacingCamera;
  @override
  bool get isInsideBoundingBox;
  @override
  Size get absoluteImageSize;
  @override
  InputImageRotation get imageRotation;
  @override
  Size get croppedSize;
  @override
  @JsonKey(ignore: true)
  _$$_FaceDetectionModelCopyWith<_$_FaceDetectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}
