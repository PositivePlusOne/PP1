// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';

class GalleryEntry {
  const GalleryEntry({
    required this.reference,
    this.mimeType,
    this.data,
    this.storageDownloadTask,
    this.storageUploadTask,
  });

  final Reference reference;
  final String? mimeType;
  final Uint8List? data;
  final DownloadTask? storageDownloadTask;
  final UploadTask? storageUploadTask;

  bool get isUploaded => storageUploadTask?.snapshot.state == TaskState.success;
}
