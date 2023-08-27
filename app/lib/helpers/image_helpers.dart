// Dart imports:

// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:universal_platform/universal_platform.dart';

Color? getMostCommonColor(Uint8List bytes) {
  img.Image? image = img.decodeImage(bytes);
  if (image == null) {
    return null;
  }

  Map<String, int> colorFrequency = {};

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      img.Pixel color = image.getPixel(x, y);
      String colorKey = '${color.r},${color.g},${color.b},${color.a}';

      if (colorFrequency.containsKey(colorKey)) {
        colorFrequency[colorKey] = colorFrequency[colorKey]! + 1;
      } else {
        colorFrequency[colorKey] = 1;
      }
    }
  }

  String mostCommonColorKey = colorFrequency.entries.fold('', (prev, entry) {
    return (prev.isEmpty || entry.value > colorFrequency[prev]!) ? entry.key : prev;
  });

  List<String> rgba = mostCommonColorKey.split(",");

  // Convert to Flutter color object
  return Color.fromARGB(255, int.parse(rgba[0]), int.parse(rgba[1]), int.parse(rgba[2]));
}

Uint8List applyColorMatrix(Uint8List imageData, List<double> matrix) {
  final img.Image? image = img.decodeImage(imageData);
  if (image == null) {
    return Uint8List.fromList(imageData);
  }

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;
      final a = pixel.a;

      // Apply the matrix to the pixel.
      final rNew = (matrix[0] * r + matrix[1] * g + matrix[2] * b + matrix[3] * a + matrix[4]).clamp(0, 255).round();
      final gNew = (matrix[5] * r + matrix[6] * g + matrix[7] * b + matrix[8] * a + matrix[9]).clamp(0, 255).round();
      final bNew = (matrix[10] * r + matrix[11] * g + matrix[12] * b + matrix[13] * a + matrix[14]).clamp(0, 255).round();
      final aNew = (matrix[15] * r + matrix[16] * g + matrix[17] * b + matrix[18] * a + matrix[19]).clamp(0, 255).round();

      // Set the new pixel value.
      image.setPixelRgba(x, y, rNew, gNew, bNew, aNew);
    }
  }

  final encodedImage = img.encodeJpg(image);
  return Uint8List.fromList(encodedImage);
}

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
