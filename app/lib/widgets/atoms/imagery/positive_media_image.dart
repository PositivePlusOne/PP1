// Flutter imports:
import 'dart:io';
import 'dart:typed_data';

import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/services/third_party.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

class PositiveMediaImage extends ConsumerStatefulWidget {
  const PositiveMediaImage({
    required this.media,
    this.backgroundColor = Colors.transparent,
    this.placeholderBuilder,
    this.errorBuilder,
    this.height,
    this.width,
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

  _PositiveImageType imageType = _PositiveImageType.none;
  Uint8List? imageBytes;

  static const String kKeyPrefix = 'media_image_';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);
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
    final DefaultCacheManager cacheManager = await ref.read(defaultCacheManagerProvider.future);
    final String jsonKey = widget.media.toJson().toString();
    final String key = kKeyPrefix + jsonKey;

    final FileInfo? cachedFile = await cacheManager.getFileFromCache(key);
    if (cachedFile != null) {
      final Uint8List bytes = await cachedFile.file.readAsBytes();
      setStateIfMounted(callback: () {
        imageBytes = bytes;
      });
    }

    return cachedFile != null;
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
    widget.media.thumbnails.sort((MediaThumbnail a, MediaThumbnail b) => (a.height - thumbnailTargetSize.value).abs().compareTo((b.height - thumbnailTargetSize.value).abs()));

    final MediaThumbnail? thumbnail = widget.media.thumbnails.firstWhereOrNull((MediaThumbnail thumbnail) => thumbnail.height >= thumbnailTargetSize.value);
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
        final Uint8List? bucketBytes = await ref.getData();
        if (bucketBytes != null) {
          bytes = bucketBytes;
          imageType = _PositiveImageType.image;
        } else {
          imageType = _PositiveImageType.error;
        }

        cacheManager.putFile(key, bytes);
        setStateIfMounted();
        return;
      }

      final File file = await cacheManager.getSingleFile(url);
      bytes = await file.readAsBytes();
      imageType = _PositiveImageType.image;
      cacheManager.putFile(key, bytes);
      setStateIfMounted();
      return;
    } catch (e) {
      logger.e(e);
      imageType = _PositiveImageType.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageChild = const SizedBox.shrink();
    Widget placeholderChild = widget.placeholderBuilder?.call(context) ?? const SizedBox.shrink();
    Widget errorChild = widget.errorBuilder?.call(context) ?? const SizedBox.shrink();

    if (imageBytes != null && imageBytes!.isNotEmpty && imageType == _PositiveImageType.image) {
      imageChild = Image.memory(
        imageBytes!,
        height: widget.height,
        width: widget.width,
      );
    } else if (imageBytes != null && imageBytes!.isNotEmpty && imageType == _PositiveImageType.svg) {
      imageChild = SvgPicture.memory(
        imageBytes!,
        height: widget.height,
        width: widget.width,
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
