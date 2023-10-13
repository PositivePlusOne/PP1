import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
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

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(refString),
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    videoPlayerController.setVolume(1.0);
    await videoPlayerController.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return Stack(
      children: [
        Positioned.fill(
          child: VideoPlayer(videoPlayerController),
        ),
        Positioned(
          height: 45,
          top: 0,
          right: 0,
          left: 0,
          child: PositiveButton(
            colors: colours,
            label: "tst",
            primaryColor: colours.white,
            onTapped: () => videoPlayerController.play(),
          ),
        ),
      ],
    );
  }
}
