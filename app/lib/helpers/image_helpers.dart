// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;

double rotateResizeImageX(double x, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  final double xClamp = x.clamp(0.0, absoluteImageSize.height);
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return xClamp * size.width / absoluteImageSize.height;
    case InputImageRotation.rotation270deg:
      return size.width - xClamp * size.width / absoluteImageSize.height;
    default:
      return size.width - xClamp * size.width / absoluteImageSize.width;
  }
}

double rotateResizeImageY(double y, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  final double yClamp = y.clamp(0.0, absoluteImageSize.width);
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return yClamp * size.height / (absoluteImageSize.width);
    default:
      return yClamp * size.height / absoluteImageSize.height;
  }
}

img.Image convertYUV420ToImage(CameraImage cameraImage) {
  final width = cameraImage.width;
  final height = cameraImage.height;

  final yRowStride = cameraImage.planes[0].bytesPerRow;
  final uvRowStride = cameraImage.planes[1].bytesPerRow;
  final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

  final image = img.Image(width: width, height: height);

  for (var w = 0; w < width; w++) {
    for (var h = 0; h < height; h++) {
      final uvIndex = uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
      final yIndex = h * yRowStride + w;

      final y = cameraImage.planes[0].bytes[yIndex];
      final u = cameraImage.planes[1].bytes[uvIndex];
      final v = cameraImage.planes[2].bytes[uvIndex];

      final rgbData = yuv2rgb(y, u, v);
      final r = (rgbData >> 16) & 0xff;
      final g = (rgbData >> 8) & 0xff;
      final b = rgbData & 0xff;

      image.data?.setPixelRgbSafe(w, h, r, g, b);
    }
  }
  return image;
}

int yuv2rgb(int y, int u, int v) {
  // Convert yuv pixel to rgb
  var r = (y + v * 1436 / 1024 - 179).round();
  var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  var b = (y + u * 1814 / 1024 - 227).round();

  // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);

  return 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
}
