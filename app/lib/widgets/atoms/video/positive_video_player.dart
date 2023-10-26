import 'package:app/dtos/database/common/media.dart' as pp1Media;
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PositiveVideoPlayer extends StatefulHookConsumerWidget {
  const PositiveVideoPlayer({
    required this.media,
    required this.visibilityDetectorKey,
    super.key,
  });

  final pp1Media.Media media;
  final Key visibilityDetectorKey;

  @override
  ConsumerState<PositiveVideoPlayer> createState() => _PositiveVideoPlayerState();
}

class _PositiveVideoPlayerState extends ConsumerState<PositiveVideoPlayer> {
  VideoController? videoController;
  Player? player;
  double videoHeight = 200;
  double videoWidth = 200;

  @override
  void dispose() {
    if (player != null) {
      player!.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PositiveVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      _initPlayer();
    }
  }

  @override
  void initState() {
    super.initState();

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final FirebaseStorage firebaseStorage = providerContainer.read(firebaseStorageProvider);
    final Reference ref = firebaseStorage.ref(widget.media.bucketPath);
    final String refString = await ref.getDownloadURL();

    videoHeight = widget.media.height.toDouble().clamp(250, 1500);
    videoWidth = widget.media.width.toDouble().clamp(250, 1500);

    player = Player();
    videoController = VideoController(player!);
    await player!.open(Media(refString));
  }

  void onClipTap() {
    player!.state.playing ? player!.pause() : player!.play();
  }

  void onVisabilityChange(VisibilityInfo info) {
    // if (videoPlayerController != null) {
    //   return;
    // }

    // if (info.visibleFraction <= 0.05 && videoPlayerController!.value.isInitialized && videoPlayerController!.value.isPlaying) {
    //   videoPlayerController!.pause();
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return SizedBox(
        height: videoHeight,
        width: double.infinity,
        child: const Align(
          child: PositiveLoadingIndicator(),
        ),
      );
    }

    final double aspect = videoWidth / videoHeight;

    return VisibilityDetector(
      key: widget.visibilityDetectorKey,
      onVisibilityChanged: (info) => onVisabilityChange(info),
      child: PositiveTapBehaviour(
        onTap: (_) => onClipTap(),
        child: AspectRatio(
          aspectRatio: aspect,
          child: Video(
            controller: videoController!,
          ),
        ),
      ),
    );
  }
}
