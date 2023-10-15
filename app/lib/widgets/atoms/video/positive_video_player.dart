import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
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
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    final FirebaseStorage firebaseStorage = providerContainer.read(firebaseStorageProvider);
    final Reference ref = firebaseStorage.ref(widget.media.bucketPath);
    final String refString = await ref.getDownloadURL();
    // media.

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(refString),
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    await videoPlayerController.setLooping(true);
    setState(() {});
  }

  void onClipTap() {
    setStateIfMounted(
      callback: () => videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PositiveTapBehaviour(
      onTap: (_) => onClipTap(),
      child: videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            )
          : Container(),
    );
  }
}
