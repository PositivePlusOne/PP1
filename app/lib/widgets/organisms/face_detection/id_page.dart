// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';

import 'package:camera/camera.dart';

class IDPage extends StatefulHookConsumerWidget with LifecycleMixin, WidgetsBindingObserver {
  IDPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return IDPageState();
  }
}

class IDPageState extends ConsumerState<IDPage> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  FaceDetectorOptions? options;
  FaceDetector? faceDetector;
  bool cameraControllerInitialised = false;
  int cameraID = 0;
  List<Rect> faceBoxes = List.empty(growable: true);
  InputImageRotation cameraRotation = InputImageRotation.rotation0deg;
  DeviceOrientation previousCameraRotation = DeviceOrientation.landscapeLeft;
  bool _isBusy = false;

  Future<void> startCamera() async {
    cameras = await availableCameras();
    cameraID = cameras.indexOf(cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front));

    if (cameras.isEmpty || cameraControllerInitialised) {
      return;
    }

    options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options!);

    cameraController = CameraController(
      cameras[cameraID],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await cameraController?.initialize().then(
      (_) async {
        if (!mounted) {
          return;
        }
        cameraControllerInitialised = true;
        cameraController?.startImageStream(preprocessImage);
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    double scale = 1.0;
    if (cameraControllerInitialised) {
      scale = mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
    }
    if (scale < 1) scale = 1 / scale;

    return PositiveScaffold(
      onWillPopScope: () async => false,
      children: <Widget>[
        SliverFillRemaining(
          child: (!cameraControllerInitialised)
              ? Container()
              : Transform.scale(
                  scale: 0.8,
                  child: Center(
                    child: CameraPreview(
                      cameraController!,
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          boxes: faceBoxes,
                          cameraResolution: Size(
                            cameraController!.value.previewSize!.width,
                            cameraController!.value.previewSize!.height,
                          ),
                          scale: scale,
                          rotationAngle: cameraRotation,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  preprocessImage(CameraImage image) async {
    updateOrientation();
    final WriteBuffer allBytes = WriteBuffer();

    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[cameraID];
    final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    if (imageRotation == null) return;

    final InputImageFormat? inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: cameraRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    processImage(inputImage);
  }

  processImage(InputImage inputImage) async {
    if (_isBusy) return;

    _isBusy = true;

    final List<Face> faces = await faceDetector!.processImage(inputImage);
    faceBoxes.clear();
    for (var face in faces) {
      faceBoxes.add(face.boundingBox);
    }
    _isBusy = false;

    if (mounted) {
      setState(() {});
    }
  }

  void updateOrientation() {
    if (cameraController!.value.deviceOrientation != previousCameraRotation) {
      switch (cameraController!.value.deviceOrientation) {
        case DeviceOrientation.landscapeLeft:
          cameraRotation = InputImageRotation.rotation0deg;
          break;
        case DeviceOrientation.landscapeRight:
          cameraRotation = InputImageRotation.rotation180deg;
          break;
        case DeviceOrientation.portraitDown:
          cameraRotation = InputImageRotation.rotation90deg;
          break;
        case DeviceOrientation.portraitUp:
          cameraRotation = InputImageRotation.rotation270deg;
          break;
      }
      previousCameraRotation = cameraController!.value.deviceOrientation;
    }
  }
}

class BoundingBoxPainter extends CustomPainter {
  BoundingBoxPainter({
    required this.boxes,
    required this.cameraResolution,
    required this.scale,
    required this.rotationAngle,
  });
  final List<Rect> boxes;
  final Size cameraResolution;
  final double scale;
  final InputImageRotation rotationAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    if (boxes.isEmpty) {
      return;
    }
    for (Rect box in boxes) {
      Rect rect = Rect.fromLTRB(
        rotateResizeImageX(box.left, rotationAngle, size, cameraResolution),
        rotateResizeImageY(box.top, rotationAngle, size, cameraResolution),
        rotateResizeImageX(box.right, rotationAngle, size, cameraResolution),
        rotateResizeImageY(box.bottom, rotationAngle, size, cameraResolution),
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double rotateResizeImageX(double X, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return X * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return size.width - X * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    default:
      return size.width - X * size.width / absoluteImageSize.width;
  }
}

double rotateResizeImageY(double Y, InputImageRotation rotation, final Size size, final Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return Y * size.height / (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return Y * size.height / absoluteImageSize.height;
  }
}
