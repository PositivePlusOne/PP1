// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
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
  Player? player;
  String? url;
  VideoController? videoController;
  bool isLoadingVideoPlayer = false;
  bool isMuted = false;

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

  Future<void> resetPlayer() async {
    if (player?.state.playing == true) {
      await player?.stop();
    }

    player?.dispose();
    player = null;

    videoController = null;
    url = null;

    setStateIfMounted();
  }

  Future<void> handleTrackRequest() async {
    final Logger logger = providerContainer.read(loggerProvider);
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

      final Media media = Media(url!, httpHeaders: {
        'Accept': 'video/mp4',
        'Accept-Encoding': 'gzip, deflate, br',
        'Cache-Control': 'max-age=31536000',
        'Connection': 'keep-alive',
      });

      if (player?.platform?.isVideoControllerAttached == true) {
        await player?.open(media, play: true);
      }
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

    if (isMuted) {
      await player!.setVolume(100.0);
    } else {
      await player!.setVolume(0.0);
    }
    setState(() {
      isMuted = !isMuted;
    });
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

    if (videoAspectRatio > 1) {
      videoAspectRatio = 1 / videoAspectRatio;
    }

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
            maxHeight: screenHeight * 0.7,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: kPaddingInformationBreak * -1,
                right: kPaddingInformationBreak * -1,
                child: Opacity(
                  opacity: kOpacityFaint,
                  child: SvgPicture.asset(
                    SvgImages.logosCircular,
                    color: colours.colorGray8,
                    height: screenHeight * 0.5,
                    width: screenHeight * 0.5,
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: kAnimationDurationRegular,
                  child: videoController != null
                      ? Video(
                          filterQuality: FilterQuality.none,
                          alignment: Alignment.center,
                          controller: videoController!,
                          pauseUponEnteringBackgroundMode: true,
                          aspectRatio: videoAspectRatio,
                          wakelock: true,
                        )
                      : PositiveTapBehaviour(
                          isEnabled: !isLoadingVideoPlayer,
                          onTap: (_) async => handleTrackRequest(),
                          child: Center(
                            child: Icon(
                              UniconsLine.play,
                              color: colours.white,
                              size: kIconMedium,
                            ),
                          ),
                        ),
                ),
              ),
              if (videoController != null)
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
          ),
        ),
      ),
    );
  }
}
