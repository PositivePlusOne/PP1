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

  //? size is the size of the phone screen/rendered area
  //? absoluteImageSize is the dimentions of the image that was sent to the face tracking software
  //? croppedImageSize is the dimentions of the subset of the absoluteImageSize, this is the area that the face tracker has been told to look for faces in
  //? offset is the coordinate to be mapped from the face tracking coordinate system to the display coordinate system

  //? Scale factor to map coordinates from the cropped image set to the phone resolution set
  final double ratio = (size.width / croppedImageSize.width);

  //? offset marking the distance between the absolute image size and the cropped image size
  //? offset must also be multiplied by the ratio above to be mapped from the face tracker coordintate system to the phone screen coordinate system
  final double widthOffsetFT = (absoluteImageSize.height - croppedImageSize.width) / 2;
  final double heightOffsetFT = (absoluteImageSize.width - croppedImageSize.height) / 2;

  final double widthOffset = (size.width - (croppedImageSize.width * ratio)) / 2;
  final double heightOffset = (size.height - (croppedImageSize.height * ratio)) / 2;

  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return Offset(
        (offset.dx - widthOffsetFT) * ratio - widthOffset,
        size.height - ((offset.dy - heightOffsetFT) * ratio + heightOffset),
      );
    case InputImageRotation.rotation180deg:
      return Offset(
        (offset.dy - widthOffsetFT) * ratio - widthOffset,
        (offset.dx - heightOffsetFT) * ratio + heightOffset,
      );
    case InputImageRotation.rotation270deg:
      return Offset(
        size.width - (offset.dx - widthOffsetFT) * ratio - widthOffset,
        (offset.dy - heightOffsetFT) * ratio + heightOffset,
      );
    default:
      return Offset(
        size.width - (offset.dy - widthOffsetFT) * ratio - widthOffset,
        size.height - (offset.dx - heightOffsetFT) * ratio - heightOffset,
      );
  }
}
