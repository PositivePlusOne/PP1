// Dart imports:
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

double rotateResizeImageX(
  double x,
  InputImageRotation rotation,
  final Size size,
  final Size absoluteImageSize,
  final Size croppedSize,
) {
  // final double xClamp = x.clamp(0.0, absoluteImageSize.height);
  late double croppedOffset;
  double ratio = 1.0;
  ratio = croppedSize.width / absoluteImageSize.width;
  final double xDiff = size.width - absoluteImageSize.width;

  switch (rotation) {
    case InputImageRotation.rotation90deg:
      croppedOffset = (size.width - absoluteImageSize.width) / 2;
      break;
    case InputImageRotation.rotation270deg:
      croppedOffset = (absoluteImageSize.width - size.width) / 2;
      // croppedOffset = (size.width / absoluteImageSize.width);
      // return size.width - (x * (size.width / (absoluteImageSize.width )));
      break;
    default:
      croppedOffset = (size.width - absoluteImageSize.width) / 2;
      break;
  }

  return size.width - (x * (size.width) / (absoluteImageSize.width + xDiff)) - xDiff / 2;
}

double rotateResizeImageY(double y, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  final double yClamp = y.clamp(0.0, absoluteImageSize.width);
  final double yDiff = size.height - absoluteImageSize.height;
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      // return y - (640 - size.height) / 2.4;
      return (y * (size.height) / (absoluteImageSize.height + yDiff)) + yDiff / 2;
    // return y - (size.height - absoluteImageSize.width) / 2.4;
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

Uint8List encodeCameraBytes(Uint8List image, {int? width = 640, int quality = 85}) {
  final Logger logger = providerContainer.read(loggerProvider);
  logger.d('encodeCameraBytes: ${image.length} bytes');

  img.Image imgData = img.decodeImage(image)!;

  Uint8List imgJpg = img.encodeJpg(imgData);
  logger.d('encodeCameraBytes: ${imgJpg.length} bytes');

  if (width != null && width < imgData.width) {
    imgData = img.copyResize(imgData, width: width);
    imgJpg = img.encodeJpg(imgData, quality: quality);
    logger.d('encodeCameraBytes: resized to ${imgJpg.length} bytes');
  }

  return imgJpg;
}

List<int> encodeCameraImage(CameraImage image, {int? width = 640, int quality = 85}) {
  final Logger logger = providerContainer.read(loggerProvider);
  logger.d('encodeCameraImage: ${image.format} ${image.width}x${image.height}');

  // Get a byte buffer for all the planes
  final int byteLength = image.planes.fold(0, (int previousValue, Plane plane) {
    return previousValue + plane.bytes.length;
  });

  final Uint8List imgBytes = Uint8List(byteLength);
  for (int i = 0; i < image.planes.length; i++) {
    final Plane plane = image.planes[i];
    imgBytes.setRange(i * plane.bytes.length, (i + 1) * plane.bytes.length, plane.bytes);
  }

  img.Image imgData = img.Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: imgBytes.buffer,
  );

  Uint8List imgJpg = img.encodeJpg(imgData);
  logger.d('encodeCameraImage: ${imgJpg.length} bytes');

  if (width != null && width < image.width) {
    imgData = img.copyResize(imgData, width: width);
    imgJpg = img.encodeJpg(imgData, quality: quality);
    logger.d('encodeCameraImage: resized to ${imgJpg.length} bytes');
  }

  return imgJpg;
}

Future<Uint8List> imageFromRepaintBoundary(GlobalKey repaintKey) async {
  final RenderRepaintBoundary? boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  final image = await boundary!.toImage(pixelRatio: 6);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData?.buffer.asUint8List();
  return pngBytes!;
}
