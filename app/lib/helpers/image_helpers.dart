import 'dart:io';
import 'dart:ui';
import 'package:google_ml_kit/google_ml_kit.dart';

double rotateResizeImageX(double x, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  final double xClamp = x.clamp(0.0, (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height));
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return xClamp * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return size.width - xClamp * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    default:
      return size.width - xClamp * size.width / absoluteImageSize.width;
  }
}

double rotateResizeImageY(double y, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  final double yClamp = y.clamp(0.0, (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width));
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return yClamp * size.height / (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return yClamp * size.height / absoluteImageSize.height;
  }
}
