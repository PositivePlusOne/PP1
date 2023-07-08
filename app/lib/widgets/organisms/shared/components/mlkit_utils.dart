// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

extension MLKitUtils on AnalysisImage {
  InputImage toInputImage() {
    if (this is Nv21Image) {
      return (this as Nv21Image).toInputImage();
    } else if (this is Bgra8888Image) {
      return (this as Bgra8888Image).toInputImage();
    } else if (this is JpegImage) {
      return (this as JpegImage).toInputImage();
    } else if (this is Yuv420Image) {
      return (this as Yuv420Image).toInputImage();
    } else {
      throw "Unsupported AnalysisImage format: $format";
    }
  }

  InputImageRotation get inputImageRotation => InputImageRotation.values.byName(rotation.name);
}
