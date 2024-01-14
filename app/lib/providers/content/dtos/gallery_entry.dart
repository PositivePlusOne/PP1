// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Package imports:
import 'package:app/constants/compression_constants.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/services/third_party.dart';

class UploadResult {
  UploadResult({
    required this.mediaThumbnails,
  });

  final List<MediaThumbnail> mediaThumbnails;
}

class GalleryEntry {
  GalleryEntry({
    this.reference,
    this.file,
    this.mimeType,
    this.width,
    this.height,
    this.data,
    this.saveToGallery = false,
    this.storageDownloadTask,
    this.storageUploadTask,
  });

  Reference? reference;
  XFile? file;

  String? mimeType;
  int? width;
  int? height;

  Uint8List? data;

  bool saveToGallery;

  DownloadTask? storageDownloadTask;
  UploadTask? storageUploadTask;

  String get fileName {
    if (file != null) {
      return file!.name;
    } else if (reference != null) {
      return reference!.name;
    } else {
      return '';
    }
  }

  Future<Media> createMedia({AwesomeFilter? filter, String altText = '', String mimeType = ''}) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final List<MediaThumbnail> mediaThumbnails = <MediaThumbnail>[];
    logger.i('createMedia() checking if uploaded');

    final bool isUploaded = await hasBeenUploaded();
    if (!isUploaded) {
      logger.i('createMedia() uploading');
      final UploadResult result = await upload(filter: filter);
      mediaThumbnails.addAll(result.mediaThumbnails);
    }

    logger.i('createMedia() creating media');
    return Media(
      name: fileName,
      altText: altText,
      height: height ?? -1,
      width: width ?? -1,
      priority: kMediaPriorityDefault,
      bucketPath: reference!.fullPath,
      thumbnails: mediaThumbnails,
      type: MediaType.fromMimeType(mimeType, storedInBucket: true),
    );
  }

  Future<UploadResult> upload({AwesomeFilter? filter}) async {
    final GalleryController galleryController = providerContainer.read(galleryControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);
    final List<MediaThumbnail> mediaThumbnails = <MediaThumbnail>[];

    final bool hasBeenUploaded = await this.hasBeenUploaded();
    if (hasBeenUploaded) {
      logger.d('upload() hasBeenUploaded');
      return UploadResult(mediaThumbnails: mediaThumbnails);
    }

    Uint8List data = await file?.readAsBytes() ?? Uint8List(0);
    if (data.isEmpty) {
      throw Exception('GalleryEntry.upload() data is empty');
    }

    final String fileName = this.fileName;
    final String mimeType = lookupMimeType(fileName, headerBytes: data) ?? 'application/octet-stream';

    if (saveToGallery) {
      reference = galleryController.rootProfileGalleryReference.child(fileName);
    } else {
      reference = galleryController.rootProfilePublicReference.child(fileName);
    }

    if (mimeType.startsWith('image/')) {
      logger.d('upload() mimeType.startsWith(image/)');
      data = await compressImageAndApplyFilter(data: data, filter: filter);
    }

    if (mimeType.startsWith('video/')) {
      logger.d('upload() mimeType.startsWith(video/)');

      // Get a thumbnail and store it as a media thumbnail
      logger.d('upload() creating thumbnail');
      final File thumbnailFile = await createThumbnailForVideo();
      final Uint8List thumbnailData = await thumbnailFile.readAsBytes();
      final String thumbnailFileName = fileName.replaceAll(RegExp(r'\.[^\.]+$'), '_thumbnail.jpg');
      final Reference thumbnailReference = galleryController.rootProfileGalleryReference.child(thumbnailFileName);
      final UploadTask thumbnailUploadTask = thumbnailReference.putData(
        thumbnailData,
        SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public, max-age=31536000',
          contentDisposition: 'attachment; filename="$thumbnailFileName"',
        ),
      );

      await thumbnailUploadTask.whenComplete(() {});

      final MediaThumbnail mediaThumbnail = MediaThumbnail(
        bucketPath: thumbnailReference.fullPath,
        url: await thumbnailReference.getDownloadURL(),
      );

      mediaThumbnails.add(mediaThumbnail);

      //* This is optional, so leaving commented out as currently the editor will handle this
      // data = await compressVideo(data: data);
    }

    final SettableMetadata metadata = SettableMetadata(
      contentType: mimeType,
      cacheControl: 'public, max-age=31536000',
      contentDisposition: 'attachment; filename="$fileName"',
    );

    storageUploadTask = reference?.putData(data, metadata);
    await storageUploadTask!.whenComplete(() {});

    return UploadResult(mediaThumbnails: mediaThumbnails);
  }

  Future<File> createThumbnailForVideo() async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('createThumbnailForVideo()');

    final String tempFilePath = file!.path.replaceAll(RegExp(r'\.[^\.]+$'), '_thumbnail.jpg');

    // Scale the thumbnail to 1280
    final String command = '-y -i ${file!.path} -vf scale=-2:1280 -vframes 1 $tempFilePath';
    final FFmpegSession session = await FFmpegKit.executeAsync(command);

    final SessionState state = await session.getState();
    if (state == SessionState.failed) {
      final ReturnCode? returnCode = await session.getReturnCode();
      final String? output = await session.getOutput();
      final List<Log> logs = await session.getLogs();
      logger.e('createThumbnailForVideo() ffmpeg failed: $returnCode\n$output\n$logs');
      throw Exception('createThumbnailForVideo() ffmpeg failed: $returnCode\n$output\n$logs');
    }

    // Wait for the file to be written
    final File thumbnailFile = File(tempFilePath);

    int i = 0;
    while (!await thumbnailFile.exists()) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      i++;

      if (i >= 10) {
        throw Exception('createThumbnailForVideo() thumbnailFile does not exist');
      }
    }

    return thumbnailFile;
  }

  Future<Uint8List> compressVideo({required Uint8List data}) async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('upload() mimeType.startsWith(video/)');

    // Create a new file which matches the path of the current with _compressed appended
    final String tempFilePath = file!.path.replaceAll(RegExp(r'\.[^\.]+$'), '_compressed.mp4');
    await File(tempFilePath).writeAsBytes(data);

    // All videos are compressed to 720p vertically to match the aspect ratio of the app
    final String command = '-y -i ${file!.path} -vf scale=-2:720 -c:v libx264 -crf 28 -preset veryfast $tempFilePath';
    final FFmpegSession session = await FFmpegKit.executeAsync(command);

    final SessionState state = await session.getState();
    if (state == SessionState.failed) {
      final ReturnCode? returnCode = await session.getReturnCode();
      final String? output = await session.getOutput();
      final List<Log> logs = await session.getLogs();
      logger.e('upload() ffmpeg failed: $returnCode\n$output\n$logs');
      throw Exception('upload() ffmpeg failed: $returnCode\n$output\n$logs');
    }

    final Uint8List compressedData = await File(tempFilePath).readAsBytes();
    await File(tempFilePath).delete();

    return compressedData;
  }

  Future<Uint8List> compressImageAndApplyFilter({
    required Uint8List data,
    required AwesomeFilter? filter,
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('upload() mimeType.startsWith(image/)');
    if (data.isEmpty) {
      throw Exception('GalleryEntry.upload() data is empty');
    }

    // Check the image width or height does not exceed the max kImageCompressMaxWidth or kImageCompressMaxHeight
    // Use instantiateImageCodec to resize the image if it does

    // Get the image size
    ui.Codec codec = await ui.instantiateImageCodec(data);
    ui.FrameInfo frame;
    int width = 0;
    int height = 0;

    try {
      frame = await codec.getNextFrame();
      width = frame.image.width;
      height = frame.image.height;
    } finally {
      codec.dispose();
    }

    if (width == 0 || height == 0) {
      throw Exception('GalleryEntry.upload() width or height is 0');
    }

    logger.d('upload() width: $width, height: $height');
    if (width > kImageCompressMaxWidth || height > kImageCompressMaxHeight) {
      logger.d('upload() width > kImageCompressMaxWidth || height > kImageCompressMaxHeight');
      // Use ui.instantiateImageCodec to resize the image
      codec = await ui.instantiateImageCodec(data, targetWidth: kImageCompressMaxWidth, targetHeight: kImageCompressMaxHeight);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      // Convert the resized image to a byte array (jpeg)
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final Uint8List resizedData = byteData?.buffer.asUint8List() ?? Uint8List(0);
      if (byteData == null || resizedData.isEmpty) {
        throw Exception('GalleryEntry.upload() byteData is null');
      }

      logger.i('upload() resized byteData.lengthInBytes: ${byteData.lengthInBytes}');
      data = resizedData;
    }

    // Apply filter if not none
    if (filter != null && filter != AwesomeFilter.None) {
      logger.d('upload() filter != null && filter != AwesomeFilter.none');
      data = applyColorMatrix(data, filter.matrix);
    }

    return data;
  }

  Future<void> syncData() async {
    final Logger logger = providerContainer.read(loggerProvider);

    if (file != null) {
      logger.d('syncData() file != null');
      data = await file!.readAsBytes();
    } else if (reference != null) {
      logger.d('syncData() reference != null');
      data = await reference!.getData();
    } else {
      throw Exception('GalleryEntry.syncData() file and reference are null');
    }

    mimeType = lookupMimeType(fileName);
    logger.d('syncData() mimeType: $mimeType');
  }

  Future<void> waitUntilUploaded() async {
    if (storageUploadTask == null) {
      return;
    }

    await storageUploadTask!.whenComplete(() {});
  }

  Future<bool> hasBeenUploaded() async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('hasBeenUploaded() checking if uploaded');

    if (reference == null) {
      logger.d('hasBeenUploaded() reference == null');
      return false;
    }

    try {
      final FullMetadata metadata = await reference!.getMetadata();
      logger.d('hasBeenUploaded() metadata.sizeBytes: ${metadata.size}');
      return (metadata.size ?? 0) > 0;
    } catch (e) {
      logger.d('hasBeenUploaded() error: $e');
      return false;
    }
  }
}
