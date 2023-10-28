// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart' as pp1_media;
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';

class PositiveVideoPlayer extends StatefulHookConsumerWidget {
  const PositiveVideoPlayer({
    required this.media,
    required this.visibilityDetectorKey,
    this.borderRadius,
    super.key,
  });

  final pp1_media.Media media;
  final Key visibilityDetectorKey;

  final BorderRadius? borderRadius;

  @override
  ConsumerState<PositiveVideoPlayer> createState() => _PositiveVideoPlayerState();
}

class _PositiveVideoPlayerState extends ConsumerState<PositiveVideoPlayer> {
  final Player player = Player();
  late final VideoController videoController = VideoController(
    player,
    configuration: const VideoControllerConfiguration(
      androidAttachSurfaceAfterVideoParameters: true,
      enableHardwareAcceleration: true,
    ),
  );

  String? url;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    handleTrackChange();
  }

  @override
  void didUpdateWidget(covariant PositiveVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.media != oldWidget.media) {
      handleTrackChange();
    }
  }

  Future<void> handleTrackChange() async {
    if (player.state.playing) {
      await player.stop();
    }

    url = await getDownloadUrl();

    final Media media = Media(url!, httpHeaders: {
      'Accept': 'video/mp4',
      'Accept-Encoding': 'gzip, deflate, br',
      'Cache-Control': 'max-age=31536000',
      'Connection': 'keep-alive',
    });

    await player.open(media, play: false);
    setStateIfMounted();
  }

  Future<String> getDownloadUrl() async {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String mediaKey = pp1_media.Media.getKey(widget.media, null);
    final String videoUrlKey = 'url:$mediaKey';

    final String? cachedUrl = cacheController.get(videoUrlKey);
    if (cachedUrl != null) {
      return cachedUrl;
    }

    final FirebaseStorage firebaseStorage = providerContainer.read(firebaseStorageProvider);
    final Reference ref = firebaseStorage.ref(widget.media.bucketPath);
    final String url = await ref.getDownloadURL();

    cacheController.add(key: videoUrlKey, value: url);
    return url;
  }

  Future<void> onVisabilityChange(VisibilityInfo info) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool isVideoVisible = info.visibleFraction > 0;
    if (!isVideoVisible && player.state.playing) {
      logger.d('Pausing video ${widget.media.name} because it\'s not visible.');
      await player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final theme = buildVideoPlayerThemeData(colors: colors, typography: typography);

    final double size = MediaQuery.of(context).size.width;

    double? videoAspectRatio;
    if (widget.media.height > 0 && widget.media.width > 0) {
      videoAspectRatio = widget.media.width / widget.media.height;
    }

    return VisibilityDetector(
      key: widget.visibilityDetectorKey,
      onVisibilityChanged: (info) => onVisabilityChange(info),
      child: SizedBox(
        height: size,
        width: size,
        child: MaterialVideoControlsTheme(
          normal: theme,
          fullscreen: theme,
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: Video(
              filterQuality: FilterQuality.none,
              alignment: Alignment.center,
              controller: videoController,
              pauseUponEnteringBackgroundMode: true,
              width: size,
              height: size,
              aspectRatio: videoAspectRatio,
              wakelock: true,
            ),
          ),
        ),
      ),
    );
  }

  MaterialVideoControlsThemeData buildVideoPlayerThemeData({
    required DesignColorsModel colors,
    required DesignTypographyModel typography,
  }) {
    return MaterialVideoControlsThemeData(
      padding: const EdgeInsets.all(kPaddingSmallMedium),
      backdropColor: colors.black.withOpacity(kOpacityBarrier),
      seekBarThumbColor: colors.purple,
      seekBarPositionColor: colors.purple,
      seekBarBufferColor: colors.colorGray1,
      seekBarColor: colors.white,
      buttonBarButtonColor: colors.white,
      seekBarThumbSize: kVideoThumbSize,
      visibleOnMount: true,
    );
  }
}
