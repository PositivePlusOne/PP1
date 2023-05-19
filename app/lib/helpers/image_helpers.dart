// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:google_ml_kit/google_ml_kit.dart';

// Project imports:

Offset rotateResizeImage(
  Offset offset,
  InputImageRotation rotation,
  final Size size,
  final Size absoluteImageSize,
  final Size croppedImageSize,
) {
  //TODO: This will need a thorough looking at, there may be some issues with iOS as it uses a diff coordinate system
  //? 270degree rotation is functioning correctly for android, the other rotations may not function correctly
  // if (Platform.isIOS) {
  //   offset = Offset(offset.dy, offset.dx);
  // }
  double ratio = (504 / croppedImageSize.width);
  double ratio2 = (896 / croppedImageSize.height);
  return Offset(
    offset.dx * ratio + (size.width - 504) / 2,
    // offset.dx * size.height / absoluteImageSize.height - (504 - size.width) / 2,

    offset.dy * ratio2 - (size.height - 896) / 2,
    // offset.dy * 0.9 - 105, //- (absoluteImageSize.height - size.height) / 2,
  );

  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return Offset(
        offset.dx - (absoluteImageSize.width - size.width) / 2,
        size.height - offset.dy + (absoluteImageSize.height - size.height) / 2,
      );
    case InputImageRotation.rotation180deg:
      return Offset(
        offset.dy - (absoluteImageSize.height - size.width) / 2,
        offset.dx - (absoluteImageSize.width - size.height) / 2,
      );
    case InputImageRotation.rotation270deg:
      return Offset(
        size.width - offset.dx + (absoluteImageSize.width - size.width) / 2,
        offset.dy - (absoluteImageSize.height - size.height) / 2,
      );
    default:
      return Offset(
        size.width - (offset.dy - (absoluteImageSize.height - size.width) / 2),
        size.height - (offset.dx - (absoluteImageSize.width - size.height) / 2),
      );
  }
}
