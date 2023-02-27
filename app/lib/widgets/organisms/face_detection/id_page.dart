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
  List<Face> faces = List.empty(growable: true);
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
      if (mediaQuery.orientation == Orientation.portrait) {
        scale = mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      } else {
        scale = 1 / mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      }
    }
    if (scale < 1) scale = 1 / scale;

    return PositiveScaffold(
      onWillPopScope: () async => false,
      children: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
              if (cameraControllerInitialised)
                Positioned.fill(
                  child: Transform.scale(
                    scale: scale,
                    child: Center(
                      child: CameraPreview(
                        cameraController!,
                      ),
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Face Tracker Custom Painter Widget -=-=-=-=-=-
              if (cameraControllerInitialised)
                Positioned.fill(
                  child: CustomPaint(
                    painter: FaceTrackerPainter(
                      faces: faces,
                      cameraResolution: Size(
                        cameraController!.value.previewSize!.width,
                        cameraController!.value.previewSize!.height,
                      ),
                      scale: scale,
                      rotationAngle: cameraRotation,
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Cancel Button Widget -=-=-=-=-=-
              //* -=-=-=-=-=- Information Text Widget -=-=-=-=-=-
              //* -=-=-=-=-=- Take Picture Widget -=-=-=-=-=-
            ],
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

    final List<Face> newFaces = await faceDetector!.processImage(inputImage);
    faces.clear();
    faces.addAll(newFaces);

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

class FaceTrackerPainter extends CustomPainter {
  FaceTrackerPainter({
    required this.faces,
    required this.cameraResolution,
    required this.scale,
    required this.rotationAngle,
  });
  final List<Face> faces;
  final Size cameraResolution;
  final double scale;
  final InputImageRotation rotationAngle;

  @override
  void paint(Canvas canvas, Size size) {
    //todo proper checks
    final bool faceCorrect = checkFace(faces, size, rotationAngle, cameraResolution);

    final Paint outlinePaint = Paint()
      ..color = (faceCorrect) ? Colors.green : Colors.red
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = Colors.black.withAlpha(100)
      ..style = PaintingStyle.fill;

    //* -=-=-=-=-=- Transparent Shading Widget -=-=-=-=-=-
    final double edgeInsetStartX = size.width * 0.06;
    final double edgeInsetStarty = size.height * 0.15;

    final double widthOval = size.width - (2 * edgeInsetStartX);
    final double heightOval = widthOval * 1.28;

    final Path ovalPath = Path()..addOval(Rect.fromLTWH(edgeInsetStartX, edgeInsetStarty, widthOval, heightOval));
    final Path cameraPreviewPath = Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    final Path shaderPath = Path.combine(PathOperation.difference, cameraPreviewPath, ovalPath);

    canvas.drawPath(shaderPath, fillPaint);
    canvas.drawPath(ovalPath, outlinePaint);

    //? Debug code section
    //TODO add SystemController check here for dev environment
    //! final SystemEnvironment environment = ref.read(systemControllerProvider.select((value) => value.environment));
    //! if (environment == SystemEnvironment.dev) {
    if (faces.isNotEmpty) {
      final Paint outlinePaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      for (Face face in faces) {
        //? as the image must be mirrored in the z axis to make sense to the user so must the bounding box showing the face
        //? However, the method used will also flip the left and right bounds of the box, so must be adjusted
        Rect rect = Rect.fromLTRB(
          rotateResizeImageX(face.boundingBox.left, rotationAngle, size, cameraResolution),
          rotateResizeImageY(face.boundingBox.top, rotationAngle, size, cameraResolution),
          rotateResizeImageX(face.boundingBox.right, rotationAngle, size, cameraResolution),
          rotateResizeImageY(face.boundingBox.bottom, rotationAngle, size, cameraResolution),
        );

        canvas.drawRect(rect, outlinePaint);
      }

      //? Calculate the outer bounds of the target face position
      final double faceOuterBoundsLeft = size.width * 0.04;
      final double faceOuterBoundsRight = size.width - faceOuterBoundsLeft;
      final double faceOuterBoundsTop = size.height * 0.13;
      final double faceOuterBoundsBottom = size.height * 0.7;

      //? Calculate the inner bounds of the target face position
      final double faceInnerBoundsLeft = size.width * 0.40;
      final double faceInnerBoundsRight = size.width - faceInnerBoundsLeft;
      final double faceInnerBoundsTop = size.height * 0.40;
      final double faceInnerBoundsBottom = size.height * 0.5;

      final Paint tempPaint = Paint()
        ..color = Colors.yellowAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceOuterBoundsLeft, faceOuterBoundsTop, faceOuterBoundsRight, faceOuterBoundsBottom), tempPaint);

      final Paint tempPaint2 = Paint()
        ..color = Colors.orangeAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceInnerBoundsLeft, faceInnerBoundsTop, faceInnerBoundsRight, faceInnerBoundsBottom), tempPaint2);
    }

    // canvas.drawRect(Rect.fromLTWH(edgeInsetStartX, edgeInsetStarty, widthOval, heightOval), outlinePaint);
    //* -=-=-=-=-=- Tick Widget -=-=-=-=-=-
    //* -=-=-=-=-=- Face Centered Correctly Widget -=-=-=-=-=-
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

bool checkFace(List<Face> faces, Size size, InputImageRotation rotationAngle, Size cameraResolution) {
  //? Calculate the outer bounds of the target face position
  final double faceOuterBoundsLeft = size.width * 0.04;
  final double faceOuterBoundsRight = size.width - faceOuterBoundsLeft;
  final double faceOuterBoundsTop = size.height * 0.13;
  final double faceOuterBoundsBottom = size.height * 0.7;

  //? Calculate the inner bounds of the target face position
  final double faceInnerBoundsLeft = size.width * 0.40;
  final double faceInnerBoundsRight = size.width - faceInnerBoundsLeft;
  final double faceInnerBoundsTop = size.height * 0.40;
  final double faceInnerBoundsBottom = size.height * 0.5;

  bool faceFound = true;

  //? Rule: only one face per photo
  if (faces.length == 1) {
    //? Get the box containing the face
    final Rect faceBoundingBox = faces.first.boundingBox;

    //? calculate the rotated components of the face bounding box
    final double faceLeft = rotateResizeImageX(faceBoundingBox.right, rotationAngle, size, cameraResolution);
    final double faceRight = rotateResizeImageX(faceBoundingBox.left, rotationAngle, size, cameraResolution);
    final double faceTop = rotateResizeImageY(faceBoundingBox.top, rotationAngle, size, cameraResolution);
    final double faceBottom = rotateResizeImageY(faceBoundingBox.bottom, rotationAngle, size, cameraResolution);

    //? Check if the bounds of the face are within the upper and Inner bounds
    //? All checks here are for the negative outcome/proving the face is NOT within the bounds
    if (faceLeft <= faceOuterBoundsLeft || faceLeft >= faceInnerBoundsLeft) faceFound = false;
    if (faceRight >= faceOuterBoundsRight || faceRight <= faceInnerBoundsRight) faceFound = false;
    if (faceTop <= faceOuterBoundsTop || faceTop >= faceInnerBoundsTop) faceFound = false;
    if (faceBottom >= faceOuterBoundsBottom || faceBottom <= faceInnerBoundsBottom) faceFound = false;
  } else {
    return false;
  }

  return faceFound;
}

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
