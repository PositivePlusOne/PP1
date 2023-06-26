// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

part 'face_detector_model.freezed.dart';

@freezed
class FaceDetectionModel with _$FaceDetectionModel {
  const factory FaceDetectionModel({
    @Default([]) List<Face> faces,
    @Default(false) bool isFacingCamera,
    @Default(false) bool isInsideBoundingBox,
    @Default(Size.zero) Size absoluteImageSize,
    @Default(InputImageRotation.rotation0deg) InputImageRotation imageRotation,
    @Default(Size.zero) Size croppedSize,
  }) = _FaceDetectionModel;

  factory FaceDetectionModel.empty() => const FaceDetectionModel();
}
