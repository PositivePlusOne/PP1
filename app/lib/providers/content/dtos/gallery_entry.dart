// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:app/constants/compression_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/services/third_party.dart';

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
    logger.i('createMedia() checking if uploaded');

    final bool isUploaded = await hasBeenUploaded();
    if (!isUploaded) {
      logger.i('createMedia() uploading');
      await upload(filter: filter);
    }

    logger.i('createMedia() creating media');
    return Media(
      name: fileName,
      altText: altText,
      height: height ?? -1,
      width: width ?? -1,
      priority: kMediaPriorityDefault,
      bucketPath: reference!.fullPath,
      type: MediaType.fromMimeType(mimeType, storedInBucket: true),
    );
  }

  Future<void> upload({AwesomeFilter? filter}) async {
    final GalleryController galleryController = providerContainer.read(galleryControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);

    final bool hasBeenUploaded = await this.hasBeenUploaded();
    if (hasBeenUploaded) {
      logger.d('upload() hasBeenUploaded');
      return;
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

    //* This is optional, so leaving commented out as currently the editor will handle this
    // if (mimeType.startsWith('video/')) {
    //   logger.d('upload() mimeType.startsWith(video/)');
    //   data = await compressVideo(data: data);
    // }

    storageUploadTask = reference?.putData(data, SettableMetadata(contentType: mimeType));
    await storageUploadTask!.whenComplete(() {});
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

    data = await FlutterImageCompress.compressWithList(
      data,
      keepExif: kImageCompressKeepExif,
      minHeight: kImageCompressMaxHeight,
      minWidth: kImageCompressMaxWidth,
      quality: kImageCompressMaxQuality,
      format: kImageCompressFormat,
    );

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
