// Dart imports:
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart' as fsvg;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

enum PositiveThumbnailTargetSize {
  small(128),
  medium(256),
  large(512);

  const PositiveThumbnailTargetSize(this.value);
  final int value;
}

class PositiveMediaImageProvider extends ImageProvider<PositiveMediaImageProvider> {
  const PositiveMediaImageProvider({
    required this.media,
    this.useThumbnailIfAvailable = true,
    this.thumbnailTargetSize = PositiveThumbnailTargetSize.small,
  });

  final Media media;
  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize thumbnailTargetSize;

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

    return decode(bytes);
  }

  Future<Uint8List> _loadBytes() async {
    final Uint8List? bytes = await _loadFromCache();
    if (bytes != null) {
      return bytes;
    }

    if (media.url.isNotEmpty) {
      return _loadFromUrl();
    }

    if (media.bucketPath.isNotEmpty) {
      return _loadFromFirebase();
    }

    throw StateError('Unable to load image');
  }

  Future<Uint8List?> _loadFromCache() async {
    if (media.name.isEmpty) {
      return null;
    }

    try {
      final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
      final File file = await cacheManager.getSingleFile(media.key);
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

    // Cache the image
    await cacheManager.putFile(
      media.key,
      bytes,
      fileExtension: lookupMimeType(media.name, headerBytes: bytes) ?? '',
    );

    return bytes;
  }

  Future<Uint8List> _loadFromFirebase() async {
    final Reference ref = FirebaseStorage.instance.ref(media.bucketPath);
    final Uint8List? bytes = await ref.getData();
    if (bytes == null) {
      throw StateError('Unable to load image');
    }

    // Cache the image
    final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
    await cacheManager.putFile(
      media.key,
      bytes,
      fileExtension: lookupMimeType(media.name, headerBytes: bytes) ?? '',
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
    Key? key,
  }) : super(key: key);

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
  State<PositiveMediaImage> createState() => _PositiveMediaImageState();
}

class _PositiveMediaImageState extends State<PositiveMediaImage> {
  late final PositiveMediaImageProvider _imageProvider;
  late final ImageStream _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _imageProvider = PositiveMediaImageProvider(
      media: widget.media,
      useThumbnailIfAvailable: widget.useThumbnailIfAvailable,
      thumbnailTargetSize: widget.thumbnailTargetSize,
    );

    _imageStream = _imageProvider.resolve(const ImageConfiguration());
    _imageStream.addListener(ImageStreamListener(_onImageChanged));
  }

  @override
  void didUpdateWidget(PositiveMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.media.key != oldWidget.media.key) {
      _imageStream.removeListener(ImageStreamListener(_onImageChanged));
      _imageProvider = PositiveMediaImageProvider(
        media: widget.media,
        useThumbnailIfAvailable: widget.useThumbnailIfAvailable,
        thumbnailTargetSize: widget.thumbnailTargetSize,
      );

      final ImageStream newImageStream = _imageProvider.resolve(const ImageConfiguration());
      newImageStream.addListener(ImageStreamListener(_onImageChanged));
      _imageStream = newImageStream;
    }
  }

  void _onImageChanged(ImageInfo info, bool synchronousCall) {
    _imageInfo = info;
    setStateIfMounted();
  }

  @override
  void dispose() {
    _imageStream.removeListener(ImageStreamListener(_onImageChanged));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo == null) {
      return widget.placeholderBuilder?.call(context) ?? Container();
    }

    return Image(
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      image: _imageProvider,
    );
  }
}
