// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:

Offset rotateResizeImage(
  Offset offset,
  InputImageRotation rotation,
  final Size size,
  final Size absoluteImageSize,
  final Size croppedImageSize,
) {
  //? Preplace with enum or similar for porting to web (untested, may not be required?)
  late final bool isIOS;
  if (UniversalPlatform.isIOS) {
    isIOS = true;
  } else {
    isIOS = false;
  }

  //? size is the size of the phone screen/rendered area
  //? absoluteImageSize is the dimentions of the image that was sent to the face tracking software
  //? croppedImageSize is the dimentions of the subset of the absoluteImageSize, this is the area that the face tracker has been told to look for faces in
  //? offset is the coordinate to be mapped from the face tracking coordinate system to the display coordinate system

  //? Scale factor to map coordinates from the cropped image set to the phone resolution set
  late final double ratio;

  if (isIOS) {
    ratio = (size.height / croppedImageSize.height);
  } else {
    ratio = (size.width / croppedImageSize.width);
  }

  //? offset for the distance between the absolute image size and the cropped image size
  //? offset must also be multiplied by the ratio above to be mapped from the face tracker coordintate system to the phone screen coordinate system
  late final double widthOffsetFT;
  late final double heightOffsetFT;

  if (isIOS) {
    widthOffsetFT = -(absoluteImageSize.width - croppedImageSize.width) / 2;
    heightOffsetFT = -(absoluteImageSize.height - croppedImageSize.height) / 2;
  } else {
    widthOffsetFT = (absoluteImageSize.height - croppedImageSize.width) / 2;
    heightOffsetFT = (absoluteImageSize.width - croppedImageSize.height) / 2;
  }

  //? offset for the distance between the cropped image from the tracker and the display, the cropped image once again must be mapped into the correct coordinate system
  //* This line cancels out, mathmatically it is always zero, however it is being kept as a comment to provide context
  final double widthOffset = (size.width - (croppedImageSize.width * ratio)) / 2;
  final double heightOffset = (size.height - (croppedImageSize.height * ratio)) / 2;

  switch (rotation) {
    case InputImageRotation.rotation90deg:
      if (isIOS) {
        return Offset(
          size.width - ((offset.dy - widthOffsetFT) * ratio + widthOffset),
          (offset.dx - heightOffsetFT) * ratio + heightOffset,
        );
      } else {
        return Offset(
          (offset.dx - widthOffsetFT) * ratio + widthOffset,
          size.height - ((offset.dy - heightOffsetFT) * ratio + heightOffset),
        );
      }
    case InputImageRotation.rotation180deg:
      if (isIOS) {
        return Offset(
          size.width - ((offset.dx - widthOffsetFT) * ratio + widthOffset),
          size.height - ((offset.dy - heightOffsetFT) * ratio + heightOffset),
        );
      } else {
        return Offset(
          (offset.dy - widthOffsetFT) * ratio + widthOffset,
          (offset.dx - heightOffsetFT) * ratio + heightOffset,
        );
      }
    case InputImageRotation.rotation270deg:
      if (isIOS) {
        return Offset(
          ((offset.dy - widthOffsetFT) * ratio + widthOffset),
          size.height - ((offset.dx - heightOffsetFT) * ratio + heightOffset),
        );
      } else {
        return Offset(
          size.width - ((offset.dx - widthOffsetFT) * ratio + widthOffset),
          (offset.dy - heightOffsetFT) * ratio + heightOffset,
        );
      }
    case InputImageRotation.rotation0deg:
    default:
      if (isIOS) {
        return Offset(
          (offset.dx - widthOffsetFT) * ratio + widthOffset,
          (offset.dy - heightOffsetFT) * ratio + heightOffset,
        );
      } else {
        return Offset(
          size.width - ((offset.dy - widthOffsetFT) * ratio + widthOffset),
          size.height - ((offset.dx - heightOffsetFT) * ratio + heightOffset),
        );
      }
  }
}
