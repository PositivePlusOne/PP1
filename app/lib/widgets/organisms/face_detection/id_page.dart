// Flutter imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
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

  Color camTest = Colors.amber;

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
    );
    await cameraController?.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        camTest = Colors.blue;
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
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    mediaQuery.orientation;

    double scale = 1.0;
    if (cameraControllerInitialised) {
      scale = mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
    }
    if (scale < 1) scale = 1 / scale;

    return PositiveScaffold(
      // backgroundColor: backgroundColor,
      onWillPopScope: () async => false,
      children: <Widget>[
        SliverFillRemaining(
          // child: Container(color: Colors.black),
          child: Stack(
            children: [
              (!cameraControllerInitialised)
                  ? Container()
                  : Transform.scale(
                      scale: 0.8,
                      child: Center(
                        child: CameraPreview(
                          cameraController!,
                          child: CustomPaint(
                            painter: boundingBoxPainter(
                              boxes: faceBoxes,
                              cameraResolution: Size(
                                cameraController!.value.previewSize!.width,
                                cameraController!.value.previewSize!.height,
                              ),
                              scale: scale,
                              rotationAngle: cameraController!.description.sensorOrientation,
                            ),
                          ),
                        ),
                      )),
              Positioned(
                bottom: 0.0,
                child: Container(
                  color: camTest,
                  width: 100,
                  height: 100,
                ),
              ),
              // Positioned.fill(
              //   child: CustomPaint(
              //     painter: boundingBoxPainter(faceBoxes),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  preprocessImage(CameraImage image) {
    cameraController!.description.sensorOrientation;
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
      imageRotation: InputImageRotation.rotation0deg,
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

    if (faces.isNotEmpty) {
      camTest = Colors.green;
    } else {
      camTest = Colors.red;
    }

    _isBusy = false;

    if (mounted) {
      setState(() {});
    }
  }
}

class boundingBoxPainter extends CustomPainter {
  boundingBoxPainter({
    required this.boxes,
    required this.cameraResolution,
    required this.scale,
    required this.rotationAngle,
  });
  final List<Rect> boxes;
  final Size cameraResolution;
  final double scale;
  final int rotationAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    if (boxes.isEmpty) {
      return;
    }
    // Rect rect = Rect.fromLTRB(
    //   (boxes.first.left / width) * size.width,
    //   0,
    //   0,
    //   100,
    //   // (boxes.first.width / width) * size.width,
    //   // (boxes.first.height / height) * size.height,
    // );
    Size absoluteImageSize = Size(cameraResolution.width, cameraResolution.height);
    // InputImageRotation rotation = InputImageRotation.rotation270deg;

    Rect rect = Rect.fromLTRB(
      translateX(boxes.first.left, rotationAngle, size, absoluteImageSize),
      translateY(boxes.first.top, rotationAngle, size, absoluteImageSize),
      translateX(boxes.first.right, rotationAngle, size, absoluteImageSize),
      translateY(boxes.first.bottom, rotationAngle, size, absoluteImageSize),
    );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double translateX(double X, int rotation, final Size size, final Size absoluteImageSize) {
  switch (rotation) {
    case 90:
      return X * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case 270:
      return size.width - X * size.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    default:
      return X * size.width / absoluteImageSize.width;
  }
}

double translateY(double Y, int rotation, final Size size, final Size absoluteImageSize) {
  switch (rotation) {
    case 90:
    case 270:
      return Y * size.height / (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return Y * size.height / absoluteImageSize.height;
  }
}
