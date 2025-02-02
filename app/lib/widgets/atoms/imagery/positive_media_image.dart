// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/common/events/force_media_fetch_event.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';

enum PositiveThumbnailTargetSize {
  small(128),
  medium(256),
  large(512),
  extraLarge(1280);

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

  static const int kMaximumFileSize = 1024 * 1024 * 25;

  final Media media;
  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize? thumbnailTargetSize;
  final Function(String mimeType, Uint8List bytes)? onBytesLoaded;

  @override
  Future<PositiveMediaImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PositiveMediaImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(PositiveMediaImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Path: ${media.url}');
      },
    );
  }

  Future<Codec> loadAsync(PositiveMediaImageProvider key, ImageDecoderCallback decode) async {
    assert(key == this);
    final Uint8List bytes = await loadBytes();
    if (bytes.lengthInBytes == 0) {
      throw StateError('Unable to load image');
    }

    final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
    if (mimeType == 'image/svg+xml') {
      return Future<Codec>.error('SVG doesn\'t need to be decoded using ImageProvider.');
    } else {
      return decode(await ImmutableBuffer.fromUint8List(bytes));
    }
  }

  FutureOr<Uint8List> loadBytes() async {
    Uint8List? bytes = await loadFromFileCache();

    if (media.bucketPath.isNotEmpty) {
      bytes ??= await loadFromFirebase();
    }

    if (media.url.isNotEmpty) {
      final bool isRemoteUrl = media.url.startsWith('http');
      bytes ??= isRemoteUrl ? await loadFromUrl() : await loadFromLocalFile();
    }

    bytes ??= Uint8List(0);
    if (onBytesLoaded != null) {
      final String mimeType = lookupMimeType(media.name, headerBytes: bytes) ?? '';
      onBytesLoaded!(mimeType, bytes);
    }

    return bytes;
  }

  Future<Uint8List?> loadFromFileCache() async {
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
      final File file = await cacheManager.getSingleFile(media.bucketPath, key: key);
      if (file.existsSync() == false) {
        return null;
      }

      return file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List> loadFromLocalFile() async {
    final File file = File(media.url);
    if (file.existsSync() == false) {
      throw StateError('Unable to load image');
    }

    return file.readAsBytes();
  }

  Future<Uint8List> loadFromUrl() async {
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

  Future<Uint8List> loadFromFirebase({String? expectedFileExtension}) async {
    final Logger logger = providerContainer.read(loggerProvider);
    Reference ref = FirebaseStorage.instance.ref(media.bucketPath);

    if (thumbnailTargetSize != null && useThumbnailIfAvailable) {
      final String bucketPathWithoutFilename = media.bucketPath.substring(0, media.bucketPath.lastIndexOf('/'));
      final String filenameWithoutExtension = media.name.substring(0, media.name.lastIndexOf('.'));
      final String fileExtension = expectedFileExtension ?? media.name.split('.').last;

      final Reference thumbnailReference = FirebaseStorage.instance.ref('$bucketPathWithoutFilename/thumbnails');

      // File will with be filename + extension + suffix or filename + suffix + extension
      final String filenameTypeOne = '$filenameWithoutExtension.${fileExtension}_${thumbnailTargetSize!.fileSuffix}';
      final String filenameTypeTwo = '${filenameWithoutExtension}_${thumbnailTargetSize!.fileSuffix}.$fileExtension';
      bool hasThumbnail = false;

      try {
        final meta = await thumbnailReference.child(filenameTypeOne).getMetadata();
        logger.d('Found thumbnail for ${media.name} at ${meta.fullPath}');
        ref = thumbnailReference.child(filenameTypeOne);
        hasThumbnail = true;
      } catch (e) {
        logger.d('No thumbnail for ${media.name} at ${thumbnailReference.child(filenameTypeOne).fullPath}');
      }

      if (!hasThumbnail) {
        try {
          final meta = await thumbnailReference.child(filenameTypeTwo).getMetadata();
          logger.d('Found thumbnail for ${media.name} at ${meta.fullPath}');
          ref = thumbnailReference.child(filenameTypeTwo);
          hasThumbnail = true;
        } catch (e) {
          logger.d('No thumbnail for ${media.name} at ${thumbnailReference.child(filenameTypeTwo).fullPath}');
        }
      }
    }

    Uint8List bytes = Uint8List(0);

    try {
      bytes = await ref.getData(kMaximumFileSize) ?? Uint8List(0);
    } catch (e) {
      logger.e('Unable to load image: $e');
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

class PositiveMediaImage extends ConsumerStatefulWidget {
  const PositiveMediaImage({
    required this.media,
    this.analyticsProperties = const {},
    this.backgroundColor = Colors.transparent,
    this.placeholderBuilder,
    this.errorBuilder,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.useThumbnailIfAvailable = true,
    this.thumbnailTargetSize = PositiveThumbnailTargetSize.small,
    this.onTap,
    this.isEnabled = true,
    this.onBytesLoaded,
    this.colorBlendMode,
    super.key,
  });

  final Media media;
  final Color backgroundColor;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;
  final void Function(String mimeType, Uint8List bytes)? onBytesLoaded;

  final Map<String, Object?> analyticsProperties;

  final double? height;
  final double? width;
  final BoxFit fit;

  final VoidCallback? onTap;
  final bool isEnabled;

  final bool useThumbnailIfAvailable;
  final PositiveThumbnailTargetSize? thumbnailTargetSize;

  final BlendMode? colorBlendMode;

  @override
  ConsumerState<PositiveMediaImage> createState() => PositiveMediaImageState();
}

class PositiveMediaImageState extends ConsumerState<PositiveMediaImage> {
  PositiveMediaImageProvider? _imageProvider;
  Uint8List bytes = Uint8List(0);
  StreamSubscription<ForceMediaFetchEvent>? _forceMediaFetchSubscription;

  bool isSvg = false;

  @override
  void initState() {
    super.initState();
    onForceMediaFetchCalled(ForceMediaFetchEvent(media: widget.media));
  }

  @override
  void dispose() {
    _forceMediaFetchSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String key = Media.getKey(widget.media, widget.thumbnailTargetSize);
    final String oldKey = Media.getKey(oldWidget.media, widget.thumbnailTargetSize);

    if (key != oldKey) {
      onForceMediaFetchCalled(ForceMediaFetchEvent(media: widget.media));
    }
  }

  static void clearCacheProvidersForMedia(Media media) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    final List<String> cacheKeys = [
      'image_provider:${Media.getKey(media, null)}',
      for (final PositiveThumbnailTargetSize size in PositiveThumbnailTargetSize.values) 'image_provider:${Media.getKey(media, size)}',
    ];

    logger.d('Clearing media cache for ${media.name} with keys: $cacheKeys');
    cacheController.removeSet(cacheKeys);
  }

  Future<void> onForceMediaFetchCalled(ForceMediaFetchEvent event) async {
    bytes = Uint8List(0);
    isSvg = false;
    setStateIfMounted();

    _imageProvider = PositiveMediaImageProvider(
      media: widget.media,
      useThumbnailIfAvailable: widget.useThumbnailIfAvailable,
      thumbnailTargetSize: widget.thumbnailTargetSize,
      onBytesLoaded: onBytesLoaded,
    );

    await _forceMediaFetchSubscription?.cancel();
    _forceMediaFetchSubscription = providerContainer.read(eventBusProvider).on<ForceMediaFetchEvent>().listen(onForceMediaFetchCalled);

    await _imageProvider!.loadBytes();
  }

  void onBytesLoaded(String mimeType, Uint8List bytes) {
    if (this.bytes == bytes || bytes.isEmpty) {
      return;
    }

    this.bytes = bytes;
    isSvg = mimeType == 'image/svg+xml';
    widget.onBytesLoaded?.call(mimeType, bytes);

    setStateIfMounted();
  }

  Map<String, Object?> generateMergedAnalyticProperties() {
    final Map<String, Object?> mediaProperties = {
      'media_name': widget.media.name,
      'media_type': widget.media.type.toAnalyticsName,
      'media_url': widget.media.url,
      'media_bucket_path': widget.media.bucketPath,
      'media_priority': widget.media.priority,
      'media_alt_text': widget.media.altText,
      'media_width': widget.media.width,
      'media_height': widget.media.height,
      'media_is_sensitive': widget.media.isSensitive,
      'media_is_private': widget.media.isPrivate,
      'media_has_thumbnail': widget.media.thumbnails.isNotEmpty,
      'media_thumbnail_count': widget.media.thumbnails.length,
    };

    return {...widget.analyticsProperties, ...mediaProperties};
  }

  void recordAnalytics() {
    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
    analyticsController.trackEvent(AnalyticEvents.photoViewed, properties: generateMergedAnalyticProperties());
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    Widget child = widget.placeholderBuilder?.call(context) ?? SizedBox(height: widget.height, width: widget.width);
    if (bytes.isNotEmpty) {
      if (isSvg) {
        child = SvgPicture.memory(
          bytes,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          colorBlendMode: widget.colorBlendMode ?? BlendMode.srcIn,
          // any other properties you need
        );
      } else {
        child = Image.memory(
          bytes,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          gaplessPlayback: true,
          colorBlendMode: widget.colorBlendMode,
        );
      }
    }

    // If bytes are available and alt text is available, wrap the image in a tooltip
    if (bytes.isNotEmpty && widget.media.altText.isNotEmpty) {
      child = Stack(
        children: <Widget>[
          Positioned.fill(
            child: child,
          ),
          Positioned(
            bottom: kPaddingSmall,
            left: kPaddingSmall,
            child: PositiveButton(
              label: 'Alt',
              colors: colors,
              primaryColor: colors.white.withOpacity(0.07),
              fontColorOverride: colors.white,
              size: PositiveButtonSize.medium,
              style: PositiveButtonStyle.primary,
              layout: PositiveButtonLayout.textOnly,
              onTapped: onAltTextSelected,
            ),
          ),
        ],
      );
    }

    return PositiveTapBehaviour(
      isEnabled: widget.isEnabled,
      showDisabledState: false,
      onTap: onInternalTap,
      child: Material(
        color: widget.backgroundColor,
        child: child,
      ),
    );
  }

  FutureOr<void> onInternalTap(BuildContext context) async {
    recordAnalytics();

    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    await appRouter.push(MediaRoute(media: widget.media));
  }

  FutureOr<void> onAltTextSelected() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    logger.i('Showing alt text dialog');
    await PositiveDialog.show(
      context: context,
      title: 'Alt Text',
      barrierDismissible: true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.media.altText,
          style: typography.styleBody.copyWith(color: colors.white),
        ),
      ),
    );
  }
}
