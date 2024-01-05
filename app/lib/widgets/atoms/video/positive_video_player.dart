// Dart imports:
import 'dart:async';
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
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:unicons/unicons.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart' as pp1_media;
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveVideoPlayer extends StatefulHookConsumerWidget {
  const PositiveVideoPlayer({
    required this.media,
    required this.visibilityDetectorKey,
    this.analyticsProperties = const {},
    this.borderRadius,
    super.key,
  });

  final pp1_media.Media media;
  final Key visibilityDetectorKey;
  final Map<String, Object?> analyticsProperties;

  final BorderRadius? borderRadius;

  @override
  ConsumerState<PositiveVideoPlayer> createState() => _PositiveVideoPlayerState();
}

class _PositiveVideoPlayerState extends ConsumerState<PositiveVideoPlayer> {
  Player? player;
  String? url;
  Uint8List thumbnailData = Uint8List(0);

  VideoController? videoController;
  bool isLoadingVideoPlayer = false;
  bool isMuted = false;

  bool hasTrackedEngagement = false;
  StreamSubscription<Duration>? durationSubscription;
  StreamSubscription<bool>? completionSubscription;

  // There is "some" science behind this.
  // @see: https://www.techsmith.com/blog/measure-video-engagement/
  // The nose and the tail are usually the first and last 2% of the video.
  // However this is could be short given the video is short.
  // So we have a static value of 15 seconds.
  // If the video is longer than 5 seconds, we use the 2% rule.
  // If the video is shorter than 5 seconds, we check for completion.
  static const Duration kEngagementMaximumDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadVideoThumbnail());
  }

  @override
  void dispose() {
    player?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PositiveVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.media != oldWidget.media) {
      resetPlayer();
    }
  }

  Future<void> loadVideoThumbnail() async {
    final Logger logger = providerContainer.read(loggerProvider);
    if (thumbnailData.isNotEmpty) {
      return;
    }

    final pp1_media.MediaThumbnail? thumbnail = widget.media.thumbnails.firstWhereOrNull((element) => element.bucketPath.isNotEmpty);
    final DefaultCacheManager cacheManager = await providerContainer.read(defaultCacheManagerProvider.future);
    logger.d('Loading video thumbnail for ${widget.media.name}');

    if (thumbnail == null) {
      logger.w('No video thumbnail found for ${widget.media.name}');
      return;
    }

    final String bucketPath = thumbnail.bucketPath;
    if (bucketPath.isEmpty) {
      logger.w('No video thumbnail found for ${widget.media.name}');
      return;
    }

    final FileInfo? info = await cacheManager.getFileFromMemory(bucketPath);
    if (info != null) {
      logger.d('Video thumbnail for ${widget.media.name} found in cache');
      thumbnailData = info.file.readAsBytesSync();
      setStateIfMounted();
      return;
    }

    final FirebaseStorage firebaseStorage = providerContainer.read(firebaseStorageProvider);
    final Reference ref = firebaseStorage.ref(bucketPath);
    final Uint8List? newThumbnailData = await ref.getData();
    if (newThumbnailData == null) {
      logger.w('No video thumbnail found for ${widget.media.name}');
      return;
    }

    logger.d('Video thumbnail for ${widget.media.name} downloaded from Firebase');
    thumbnailData = newThumbnailData;
    await cacheManager.putFile(bucketPath, newThumbnailData);
    setStateIfMounted();
  }

  Future<void> resetPlayer() async {
    if (player?.state.playing == true) {
      await player?.stop();
    }

    player?.dispose();
    player = null;

    videoController = null;
    url = null;

    thumbnailData = Uint8List(0);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadVideoThumbnail());

    setStateIfMounted();
  }

  Future<void> handleTrackRequest() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);

    try {
      isLoadingVideoPlayer = true;
      url = await getDownloadUrl();

      player ??= Player();
      videoController ??= VideoController(
        player!,
        configuration: const VideoControllerConfiguration(
          androidAttachSurfaceAfterVideoParameters: true,
          enableHardwareAcceleration: true,
        ),
      );

      await durationSubscription?.cancel();
      durationSubscription = player?.stream.duration.listen(trackDurationAnalytics);

      await completionSubscription?.cancel();
      player?.stream.completed.listen(onCompletionEvent);

      final Media media = Media(url!, httpHeaders: {
        'Accept': 'video/mp4',
        'Accept-Encoding': 'gzip, deflate, br',
        'Cache-Control': 'max-age=31536000',
        'Connection': 'keep-alive',
      });

      if (player?.platform?.isVideoControllerAttached != true) {
        logger.w('Video player is not attached to the platform');
        return;
      }

      await player?.open(media, play: true);
      analyticsController.trackEvent(AnalyticEvents.videoViewed, properties: generateMergedAnalyticProperties());
    } catch (ex) {
      logger.e('Failed to load video player for ${widget.media.name}');
      await resetPlayer();
    } finally {
      isLoadingVideoPlayer = false;
      setStateIfMounted();
    }
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
    if (!isVideoVisible && player?.state.playing == true) {
      logger.d('Pausing video ${widget.media.name} because it\'s not visible.');
      await player?.pause();
    }
  }

  Future<void> onToggleMute() async {
    if (player == null) {
      return;
    }

    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);

    if (isMuted) {
      await player!.setVolume(100.0);
      analyticsController.trackEvent(AnalyticEvents.videoUnmuted, properties: widget.analyticsProperties);
      setStateIfMounted(callback: () => isMuted = false);
      return;
    }

    await player!.setVolume(0.0);
    analyticsController.trackEvent(AnalyticEvents.videoMuted, properties: widget.analyticsProperties);
    setStateIfMounted(callback: () => isMuted = true);
  }

  Map<String, Object?> generateMergedAnalyticProperties() {
    final Map<String, Object?> videoProperties = {
      'video_name': widget.media.name,
      'video_url': widget.media.url,
      'video_bucket_path': widget.media.bucketPath,
      'video_type': widget.media.type.toAnalyticsName,
      'video_priority': widget.media.priority,
      'video_is_private': widget.media.isPrivate,
      'video_is_sensitive': widget.media.isSensitive,
    };

    return {...widget.analyticsProperties, ...videoProperties};
  }

  Duration getExpectedEngagementDuration() {
    final Duration totalDuration = videoController?.player.state.duration ?? Duration.zero;
    if (totalDuration == Duration.zero) {
      return Duration.zero;
    }

    final Duration watchedDuration = videoController?.player.state.position ?? Duration.zero;
    if (watchedDuration == Duration.zero) {
      return Duration.zero;
    }

    // If the video is less than 5 seconds, we use 98% of the video.
    if (totalDuration < kEngagementMaximumDuration) {
      return totalDuration * 0.98;
    }

    // If the video is longer than 5 seconds, we use 5 seconds.
    return kEngagementMaximumDuration;
  }

  void trackDurationAnalytics(Duration durationElapsed) {
    if (hasTrackedEngagement) {
      return;
    }

    final Duration expectedEngagementDuration = getExpectedEngagementDuration();
    if (expectedEngagementDuration == Duration.zero) {
      return;
    }

    final Duration videoDuration = videoController?.player.state.duration ?? Duration.zero;
    if (videoDuration == Duration.zero) {
      return;
    }

    if (durationElapsed < expectedEngagementDuration) {
      return;
    }

    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
    analyticsController.trackEvent(AnalyticEvents.videoViewedWithEngagement, properties: generateMergedAnalyticProperties());
    hasTrackedEngagement = true;
  }

  void onCompletionEvent(bool isCompleted) {
    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
    analyticsController.trackEvent(AnalyticEvents.videoViewedFully, properties: generateMergedAnalyticProperties());
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    // final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double? videoAspectRatio;

    if (widget.media.height > 0 && widget.media.width > 0) {
      videoAspectRatio = widget.media.width / widget.media.height;
    } else {
      videoAspectRatio = 1.0;
    }

    // if (videoAspectRatio > 1) {
    //   videoAspectRatio = 1 / videoAspectRatio;
    // }

    //? Clamp for excessive wide/tall videos
    videoAspectRatio = videoAspectRatio.clamp(-1.0, 2.0);

    return VisibilityDetector(
      key: widget.visibilityDetectorKey,
      onVisibilityChanged: (info) => onVisabilityChange(info),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Container(
          color: colours.black,
          constraints: BoxConstraints(
            minWidth: screenWidth,
            maxWidth: screenWidth,
            maxHeight: (screenWidth / videoAspectRatio),
          ),
          child: Stack(
            children: <Widget>[
              if (videoController == null) ...<Widget>[
                if (thumbnailData.isEmpty) ...<Widget>[
                  Positioned(
                    bottom: kPaddingInformationBreak * -1,
                    right: kPaddingInformationBreak * -1,
                    child: Opacity(
                      opacity: kOpacityFaint,
                      child: SvgPicture.asset(
                        SvgImages.logosCircular,
                        colorFilter: ColorFilter.mode(colours.colorGray8, BlendMode.srcIn),
                        height: screenHeight * 0.5,
                        width: screenHeight * 0.5,
                      ),
                    ),
                  ),
                ],
                if (thumbnailData.isNotEmpty) ...<Widget>[
                  Positioned.fill(
                    child: Image.memory(
                      thumbnailData,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                Positioned.fill(
                  child: PositiveTapBehaviour(
                    isEnabled: !isLoadingVideoPlayer,
                    hitTestBehaviourOverride: HitTestBehavior.opaque,
                    onTap: (_) async => handleTrackRequest(),
                    child: Center(
                      child: SizedBox(
                        width: kIconMedium * 2,
                        height: kIconMedium * 2,
                        child: Icon(
                          UniconsLine.play,
                          color: colours.white,
                          size: kIconMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (videoController != null) ...<Widget>[
                Positioned.fill(
                  child: Video(
                    filterQuality: FilterQuality.none,
                    alignment: Alignment.center,
                    controller: videoController!,
                    pauseUponEnteringBackgroundMode: true,
                    aspectRatio: videoAspectRatio,
                    fit: BoxFit.fitHeight,
                    wakelock: true,
                  ),
                ),
                Positioned(
                  top: kPaddingMedium,
                  right: kPaddingMedium,
                  child: PositiveButton.appBarIcon(
                    style: PositiveButtonStyle.primary,
                    colors: colours,
                    icon: isMuted ? UniconsLine.volume_mute : UniconsLine.volume,
                    foregroundColor: colours.white,
                    primaryColor: colours.white.withOpacity(0.1),
                    onTapped: () => onToggleMute(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
