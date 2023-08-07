// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:app/constants/design_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

enum PositiveThumbnailTargetSize {
  small(128),
  medium(256),
  large(512);

  String get fileSuffix => '${value}x$value';

  const PositiveThumbnailTargetSize(this.value);
  final int value;
}

class PositiveMediaImageProvider extends ImageProvider<PositiveMediaImageProvider> {
  const PositiveMediaImageProvider({
    required this.media,
    this.useThumbnailIfAvailable = true,
    this.thumbnailTargetSize = PositiveThumbnailTargetSize.small,
    this.onBytesLoaded,
  });

  final Media media;
  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize? thumbnailTargetSize;
  final Function(String mimeType, Uint8List bytes)? onBytesLoaded;

  @override
  Future<PositiveMediaImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PositiveMediaImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(PositiveMediaImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Path: ${media.url}');
      },
    );
  }

  Future<Codec> _loadAsync(PositiveMediaImageProvider key, DecoderCallback decode) async {
    assert(key == this);
    final Uint8List bytes = await _loadBytes();
    if (bytes.lengthInBytes == 0) {
      throw StateError('Unable to load image');
    }

    final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
    if (mimeType == 'image/svg+xml') {
      return Future<Codec>.error('SVG doesn\'t need to be decoded using ImageProvider.');
    } else {
      return decode(bytes);
    }
  }

  Future<Uint8List> _loadBytes() async {
    Uint8List? bytes = await _loadFromCache();
    if (media.bucketPath.isNotEmpty) {
      bytes ??= await _loadFromFirebase();
    }

    if (media.url.isNotEmpty) {
      bytes ??= await _loadFromUrl();
    }

    bytes ??= Uint8List(0);
    if (onBytesLoaded != null) {
      final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
      onBytesLoaded!(mimeType, bytes);
    }

    return bytes;
  }

  Future<Uint8List?> _loadFromCache() async {
    if (media.name.isEmpty) {
      return null;
    }

    try {
      final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
      PositiveThumbnailTargetSize? keyThumbnailSize;
      if (useThumbnailIfAvailable && thumbnailTargetSize != null) {
        keyThumbnailSize = thumbnailTargetSize;
      }

      final String key = Media.getKey(media, keyThumbnailSize);
      final File file = await cacheManager.getSingleFile(key);
      return file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List> _loadFromUrl() async {
    final HttpClientRequest request = await HttpClient().getUrl(Uri.parse(media.url));
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw StateError('Unable to load image');
    }

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
    final String key = Media.getKey(media, null);

    final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
    final String fileExtension = mimeType.split('/').last;

    // Cache the image
    await cacheManager.putFile(
      media.bucketPath,
      bytes,
      key: key,
      fileExtension: fileExtension,
    );

    return bytes;
  }

  Future<Uint8List> _loadFromFirebase() async {
    final Logger logger = providerContainer.read(loggerProvider);
    Reference ref = FirebaseStorage.instance.ref(media.bucketPath);

    if (thumbnailTargetSize != null && useThumbnailIfAvailable) {
      final String bucketPathWithoutFilename = media.bucketPath.substring(0, media.bucketPath.lastIndexOf('/'));
      final String filenameWithoutExtension = media.name.substring(0, media.name.lastIndexOf('.'));
      final String fileExtension = media.name.substring(media.name.lastIndexOf('.'));

      final String thumbnailPath = '$bucketPathWithoutFilename/thumbnails/${filenameWithoutExtension}_${thumbnailTargetSize!.fileSuffix}$fileExtension';
      final Reference thumbnailRef = FirebaseStorage.instance.ref(thumbnailPath);
      try {
        final FullMetadata metadata = await thumbnailRef.getMetadata();
        if (metadata.size != null && metadata.size! > 0) {
          ref = thumbnailRef;
        }
      } catch (e) {
        logger.e('Unable to load thumbnail: $e');
      }
    }

    Uint8List bytes = Uint8List(0);
    try {
      bytes = await ref.getData() ?? Uint8List(0);
    } catch (e) {
      logger.e('Unable to load image: $e');
    }

    if (bytes.isNotEmpty) {
      return bytes;
    }

    final String key = Media.getKey(media, thumbnailTargetSize);
    final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
    final String fileExtension = mimeType.split('/').last;
    if (bytes.lengthInBytes == 0 || fileExtension.isEmpty) {
      return bytes;
    }

    // Cache the image
    final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
    await cacheManager.putFile(
      media.bucketPath,
      bytes,
      key: key,
      fileExtension: fileExtension,
    );

    return bytes;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PositiveMediaImageProvider && other.media == media;
  }

  @override
  int get hashCode => media.hashCode;

  @override
  String toString() => '${objectRuntimeType(this, 'PositiveMediaImageProvider')}(${media.url})';
}

class PositiveMediaImage extends StatefulWidget {
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
    this.onTap,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  final Media media;
  final Color backgroundColor;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;

  final double? height;
  final double? width;
  final BoxFit fit;

  final VoidCallback? onTap;
  final bool isEnabled;

  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize? thumbnailTargetSize;

  @override
  State<PositiveMediaImage> createState() => _PositiveMediaImageState();
}

class _PositiveMediaImageState extends State<PositiveMediaImage> {
  PositiveMediaImageProvider? _imageProvider;

  ImageInfo? imageInfo;
  Uint8List bytes = Uint8List(0);
  bool isSvg = false;

  @override
  void initState() {
    super.initState();
    _imageProvider = PositiveMediaImageProvider(
      media: widget.media,
      useThumbnailIfAvailable: widget.useThumbnailIfAvailable,
      thumbnailTargetSize: widget.thumbnailTargetSize,
      onBytesLoaded: onBytesLoaded,
    );

    unawaited(_imageProvider?._loadBytes());
  }

  @override
  void didUpdateWidget(PositiveMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (Media.getKey(widget.media, widget.thumbnailTargetSize) != Media.getKey(oldWidget.media, widget.thumbnailTargetSize)) {
      _imageProvider = PositiveMediaImageProvider(
        media: widget.media,
        useThumbnailIfAvailable: widget.useThumbnailIfAvailable,
        thumbnailTargetSize: widget.thumbnailTargetSize,
        onBytesLoaded: onBytesLoaded,
      );

      unawaited(_imageProvider?._loadBytes());
    }
  }

  void onBytesLoaded(String mimeType, Uint8List bytes) {
    if (!mounted || this.bytes == bytes) {
      return;
    }

    setStateIfMounted(callback: () {
      this.bytes = bytes;
      isSvg = mimeType == 'image/svg+xml';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    if (bytes.isEmpty) {
      child = widget.placeholderBuilder?.call(context) ?? const SizedBox.shrink();
    }

    if (bytes.isNotEmpty && isSvg) {
      child = SvgPicture.memory(
        bytes,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        // any other properties you need
      );
    } else if (bytes.isNotEmpty) {
      child = Image.memory(
        bytes,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    }

    return PositiveTapBehaviour(
      isEnabled: widget.isEnabled,
      showDisabledState: false,
      onTap: onInternalTap,
      child: AnimatedOpacity(
        opacity: bytes.isEmpty ? 0 : 1,
        duration: kAnimationDurationRegular,
        child: child,
      ),
    );
  }

  FutureOr<void> onInternalTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    await appRouter.push(MediaRoute(media: widget.media));
  }
}
