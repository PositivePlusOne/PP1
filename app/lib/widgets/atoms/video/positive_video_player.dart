import 'package:app/dtos/database/common/media.dart';
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class PositiveVideoPlayer extends StatefulHookConsumerWidget {
  const PositiveVideoPlayer({
    required this.media,
    super.key,
  });

  final Media media;

  @override
  ConsumerState<PositiveVideoPlayer> createState() => _PositiveVideoPlayerState();
}

class _PositiveVideoPlayerState extends ConsumerState<PositiveVideoPlayer> {
  VideoPlayerController? videoPlayerController;

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
    // media.

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(refString),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
      ),
    )..initialize().then((_) async {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        await videoPlayerController?.setLooping(true);
        setState(() {});
      });
  }

  void onClipTap() {
    if (videoPlayerController == null) {
      return;
    }

    videoPlayerController!.value.isPlaying ? videoPlayerController!.pause() : videoPlayerController!.play();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Align(child: PositiveLoadingIndicator());
    }
    return PositiveTapBehaviour(
      onTap: (_) => onClipTap(),
      child: AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: VideoPlayer(videoPlayerController!),
      ),
    );
  }
}
