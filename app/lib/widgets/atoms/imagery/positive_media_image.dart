// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/services/third_party.dart';

class PositiveMediaImage extends ConsumerStatefulWidget {
  const PositiveMediaImage({
    required this.media,
    this.backgroundColor = Colors.transparent,
    this.placeholderBuilder,
    this.errorBuilder,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.useThumbnailIfAvailable = true,
    this.thumbnailTargetSize = PositiveThumbnailTargetSize.small,
    super.key,
  });

  final Media media;
  final Color backgroundColor;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;

  final double? height;
  final double? width;
  final BoxFit fit;

  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize thumbnailTargetSize;

  @override
  ConsumerState<PositiveMediaImage> createState() => _PositiveMediaImageState();
}

enum _PositiveImageType {
  svg,
  image,
  error,
  none,
}

enum PositiveThumbnailTargetSize {
  small(128),
  medium(256),
  large(512);

  const PositiveThumbnailTargetSize(this.value);
  final int value;
}

class _PositiveMediaImageState extends ConsumerState<PositiveMediaImage> {
  static final Lock lock = Lock();

  String get key => kKeyPrefix + widget.media.toJson().toString();

  _PositiveImageType imageType = _PositiveImageType.none;
  Uint8List imageBytes = Uint8List(0);

  static const String kKeyPrefix = 'media_image_';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);
  }

  @override
  void didUpdateWidget(PositiveMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.media.name != widget.media.name) {
      imageType = _PositiveImageType.none;
      imageBytes = Uint8List(0);
      WidgetsBinding.instance.addPostFrameCallback(onFirstRender);

      setStateIfMounted();
    }
  }

  Future<void> onFirstRender(Duration timeStamp) async {
    await lock.synchronized(() async {
      final bool resolvedFromCache = await attemptCacheLoad();
      if (!resolvedFromCache) {
        await loadMediaIntoCache();
      }
    });
  }

  Future<bool> attemptCacheLoad() async {
    if (!mounted) {
      return false;
    }

    final DefaultCacheManager cacheManager = await ref.read(defaultCacheManagerProvider.future);
    final FileInfo? cachedFile = await cacheManager.getFileFromCache(key);
    if (cachedFile != null) {
      final Uint8List bytes = await cachedFile.file.readAsBytes();
      imageBytes = bytes;
      imageType = await getImageTypeFromUint8List(bytes, path: widget.media.url);
      setStateIfMounted();
    }

    return imageBytes.isNotEmpty;
  }

  Future<void> loadMediaIntoCache() async {
    final Logger logger = ref.read(loggerProvider);
    final DefaultCacheManager cacheManager = await ref.read(defaultCacheManagerProvider.future);
    final FirebaseStorage storage = ref.read(firebaseStorageProvider);
    final String jsonKey = widget.media.toJson().toString();
    final String key = kKeyPrefix + jsonKey;
    Uint8List bytes = Uint8List(0);
    String url = '';
    String bucketPath = '';

    final PositiveThumbnailTargetSize thumbnailTargetSize = widget.thumbnailTargetSize;
    final List<MediaThumbnail> sortedThumbnails = [...widget.media.thumbnails]..sort((MediaThumbnail a, MediaThumbnail b) => (a.height - thumbnailTargetSize.value).abs().compareTo((b.height - thumbnailTargetSize.value).abs()));

    final MediaThumbnail? thumbnail = sortedThumbnails.firstWhereOrNull((MediaThumbnail thumbnail) => thumbnail.height >= thumbnailTargetSize.value);
    if (thumbnail != null && widget.useThumbnailIfAvailable) {
      url = thumbnail.url;
      bucketPath = thumbnail.bucketPath;
    } else {
      url = widget.media.url;
      bucketPath = widget.media.bucketPath;
    }

    if (widget.media.type == MediaType.bucket_path) {
      url = bucketPath;
    }

    try {
      final FileInfo? cachedFile = await cacheManager.getFileFromCache(key);
      if (cachedFile != null) {
        bytes = await cachedFile.file.readAsBytes();
        setStateIfMounted();
        return;
      }

      // If the image is a bucket path, we need to download it from the bucket
      if (widget.media.type == MediaType.bucket_path) {
        final Reference ref = storage.ref().child(url);
        final Uint8List bucketBytes = await ref.getData() ?? Uint8List(0);

        bytes = bucketBytes;
        imageType = await getImageTypeFromUint8List(bucketBytes, path: url);

        cacheManager.putFile(key, bytes);
        setStateIfMounted();
        return;
      }

      final File file = await cacheManager.getSingleFile(url);
      bytes = await file.readAsBytes();
      imageType = await getImageTypeFromUint8List(bytes, path: url);
      cacheManager.putFile(key, bytes);
      setStateIfMounted();
      return;
    } catch (e) {
      logger.e(e);
      imageType = _PositiveImageType.error;
    }
  }

  Future<_PositiveImageType> getImageTypeFromUint8List(
    Uint8List imageBytes, {
    String path = '',
  }) async {
    final String? mimeType = lookupMimeType(path, headerBytes: imageBytes);
    final String? type = mimeType?.split('/')[1];

    switch (type) {
      case 'svg+xml':
        return _PositiveImageType.svg;
      case 'png':
      case 'jpeg':
      case 'jpg':
        return _PositiveImageType.image;
      default:
        return _PositiveImageType.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageChild = const SizedBox.shrink();
    Widget placeholderChild = widget.placeholderBuilder?.call(context) ?? const SizedBox.shrink();
    Widget errorChild = widget.errorBuilder?.call(context) ?? const SizedBox.shrink();

    if (imageBytes.isNotEmpty && imageType == _PositiveImageType.image) {
      imageChild = Image.memory(
        imageBytes,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    } else if (imageBytes.isNotEmpty && imageType == _PositiveImageType.svg) {
      imageChild = SvgPicture.memory(
        imageBytes,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    } else if (imageType == _PositiveImageType.error) {
      imageChild = errorChild;
    } else if (imageType == _PositiveImageType.none) {
      imageChild = placeholderChild;
    }

    return SizedBox(
      height: widget.height ?? 0,
      width: widget.width ?? 0,
      child: imageChild,
    );
  }
}
