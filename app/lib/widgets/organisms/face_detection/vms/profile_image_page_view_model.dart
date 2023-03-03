// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image/image.dart' as img;

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/services/third_party.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'profile_image_page_view_model.freezed.dart';
part 'profile_image_page_view_model.g.dart';

@freezed
class ProfileImagePageViewModelState with _$ProfileImagePageViewModelState {
  const factory ProfileImagePageViewModelState({
    @Default(false) bool isBusy,
    //? has a face been found
    @Default(false) bool faceFound,
    //? camera has been started and is available for interactions
    @Default(false) bool cameraControllerInitialised,
  }) = _ProfileImagePageViewModelState;

  factory ProfileImagePageViewModelState.initialState() => const ProfileImagePageViewModelState();
}

@riverpod
class ProfileImagePageViewModel extends _$ProfileImagePageViewModel with LifecycleMixin {
  CameraController? cameraController;

  //? InputImageRotation is the format required for Googles MLkit face detection plugin
  InputImageRotation cameraRotation = InputImageRotation.rotation0deg;

  //? DeviceOrientation is the default format as given by the Camera package
  DeviceOrientation previousCameraRotation = DeviceOrientation.landscapeLeft;

  //? List of Cameras available
  final List<CameraDescription> cameras = List.empty(growable: true);
  int cameraID = 0;

  //? List of faces currently within the viewport
  final List<Face> faces = List.empty(growable: true);
  //? FaceDertector from google MLKit
  FaceDetector? faceDetector;

  //? Variable denoting the users reqest to take picture
  bool requestTakeSelfie = false;

  bool cameraIsStreaming = false;

  //? Throttle the face update rate
  final int throttleEnd = 5;
  int throttle = 0;

  //? get viewport scale
  double get scale {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    double scale = 1;
    if (state.cameraControllerInitialised) {
      if (mediaQuery.orientation == Orientation.portrait) {
        scale = mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      } else {
        scale = 1 / mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      }
    }
    if (scale < 1) scale = 1 / scale;
    return scale;
  }

  @override
  ProfileImagePageViewModelState build() {
    return ProfileImagePageViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    startCamera();
    super.onFirstRender();
  }

  Future<void> startCamera() async {
    final Logger logger = ref.read(loggerProvider);
    if (state.cameraControllerInitialised) {
      logger.w("Cannot run startCamera, camera controller is already initialised");
      return;
    }

    cameras.clear();
    cameras.addAll(await availableCameras());
    if (!cameras.any((element) => element.lensDirection == CameraLensDirection.front)) {
      logger.w("No camera found");
      return;
    }

    final CameraDescription selectedCamera = cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front);
    cameraID = cameras.indexOf(selectedCamera);

    final FaceDetectorOptions options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    cameraController = CameraController(
      cameras[cameraID],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController?.initialize().then(
      (_) async {
        state = state.copyWith(cameraControllerInitialised: true);
        startCameraStream();
      },
    );
  }

  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\
  //*     reformat the image data into a usable form for the google MLkit face detection       *\\
  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\
  Future<void> preprocessImage(CameraImage image) async {
    if (throttle < throttleEnd) {
      throttle++;
      return;
    }
    throttle = 0;

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

    if (requestTakeSelfie) {
      uploadImageToFirebase(image);
      requestTakeSelfie = false;
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    if (state.isBusy) return;

    state = state.copyWith(isBusy: true);

    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    final List<Face> newFaces = await faceDetector!.processImage(inputImage);
    faces.clear();
    faces.addAll(newFaces);

    final bool faceFound = checkFace(
      mediaQuery.size,
      faces,
    );
    state = state.copyWith(faceFound: faceFound);

    state = state.copyWith(isBusy: false);
  }

  bool checkFace(Size size, List<Face> facesToCheck) {
    final Size cameraResolution = Size(
      cameraController!.value.previewSize!.width,
      cameraController!.value.previewSize!.height,
    );

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
    if (facesToCheck.length == 1) {
      //? Get the box containing the face
      final Rect faceBoundingBox = facesToCheck.first.boundingBox;

      //? calculate the rotated components of the face bounding box
      final double faceLeft = rotateResizeImageX(faceBoundingBox.right, cameraRotation, size, cameraResolution);
      final double faceRight = rotateResizeImageX(faceBoundingBox.left, cameraRotation, size, cameraResolution);
      final double faceTop = rotateResizeImageY(faceBoundingBox.top, cameraRotation, size, cameraResolution);
      final double faceBottom = rotateResizeImageY(faceBoundingBox.bottom, cameraRotation, size, cameraResolution);

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

  void updateOrientation() {
    //* check the deviceOrientation and update the cameraRotation variable
    //* (google MLkit requires the orientation of the image and the video stream from the camera plugin does not contain the relavent metadata)
    //* we get the image rotation from the phone orientation this needs testing on other devices
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

  Future<void> stopCameraStream() async {
    if (cameraIsStreaming == false) {
      return;
    }
    cameraIsStreaming = false;
    await cameraController!.stopImageStream();
  }

  Future<void> startCameraStream() async {
    if (cameraIsStreaming == true) {
      return;
    }
    cameraIsStreaming = true;
    await cameraController!.startImageStream(preprocessImage);
  }

  Future<void> requestSelfie() async {
    requestTakeSelfie = true;
  }

  Future<void> uploadImageToFirebase(CameraImage image) async {
    final FirebaseStorage firebaseStorage = ref.read(firebaseStorageProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);

    final img.Image unencodedImage = _convertYUV420(image);
    final Uint8List pngImage = Uint8List.fromList(img.encodePng(unencodedImage));

    if (firebaseAuth.currentUser == null) {
      logger.e("User is not logged in");
      return;
    }
    final String path = "/users/${firebaseAuth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}";
    final Reference imageRef = firebaseStorage.ref().child(path);
    await imageRef.putData(pngImage, SettableMetadata(contentType: "image/png"));
    logger.d("Uploaded image");
  }

// CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// Black
  img.Image _convertYUV420(CameraImage image) {
    var imgage = img.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0; planeOffset < image.height * image.width; planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        imgage.data[planeOffset + x] = newVal;
      }
    }

    return imgage;
  }

  void imageTakenSuccess() {
    print("object");
  }
}
