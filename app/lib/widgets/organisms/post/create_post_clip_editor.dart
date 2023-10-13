import 'dart:io';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/organisms/post/component/positive_clip_external_shader.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:video_editor/video_editor.dart';
import 'dart:developer';

//*-------------------*//
//*VIDEO EDITOR SCREEN*//
//*-------------------*//
class VideoEditor extends StatefulHookConsumerWidget {
  const VideoEditor({
    required this.file,
    required this.function,
    required this.topNavigationSize,
    required this.bottomNavigationSize,
    required this.targetVideoAspectRatio,
    this.onTapClose,
    this.onInternalAddImageTap,
    super.key,
  });

  final File file;
  final Function(File) function;
  final double topNavigationSize;
  final double bottomNavigationSize;
  final double targetVideoAspectRatio;

  final Function(BuildContext context)? onTapClose;
  final Function(BuildContext context)? onInternalAddImageTap;

  @override
  ConsumerState<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends ConsumerState<VideoEditor> {
  final _progress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 180),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize(aspectRatio: widget.targetVideoAspectRatio).then((_) => setState(() {})).catchError((error) {
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _progress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _exportVideo() async {
    _progress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(
      _controller,
      format: VideoExportFormat.mp4,
      commandBuilder: (config, videoPath, outputPath) {
        final List<String> filters = config.getExportFilters();
        // filters.add('hflip'); // add horizontal flip

        return '-i $videoPath ${config.filtersCmd(filters)} $outputPath';
      },
    );
    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      // onProgress: (stats) {
      //   _progress.value = config.getFFmpegProgress(stats.getTime().toInt());
      // },
      onError: (e, s) {},
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;
        widget.function(file);
      },
    );
  }

  bool get checkVideoLength {
    //TODO(S): This requires a callback on the controller, when controller is remade update this
    if (_controller.trimmedDuration.inSeconds <= kMaxClipDurationSeconds) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Video Preview             -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned.fill(
                      child: CropGridViewer.preview(
                        controller: _controller,
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-           Video Trim Slider          -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned(
                      bottom: widget.bottomNavigationSize + kPaddingMediumLarge,
                      height: kIconHuge,
                      left: kPaddingMedium,
                      right: kPaddingMedium,
                      child: SizedBox(
                        height: kIconHuge,
                        child: _trimSlider(),
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Overlay Shader            -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned.fill(
                      child: PositiveClipExternalShader(
                        paddingLeft: kPaddingNone,
                        paddingRight: kPaddingNone,
                        paddingTop: widget.topNavigationSize,
                        paddingBottom: widget.bottomNavigationSize,
                        colour: colours.black.withOpacity(kOpacityVignette),
                        radius: kBorderRadiusLarge,
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Top Navigation            -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned(
                      left: kPaddingMedium,
                      right: kPaddingMedium,
                      top: kPaddingSmall,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CameraFloatingButton.close(active: true, onTap: widget.onTapClose ?? (_) {}),
                          const Spacer(),
                          CameraFloatingButton.addImage(active: true, onTap: widget.onInternalAddImageTap ?? (_) {}),
                        ],
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-         Video Error Overlay          -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned(
                      left: kPaddingMedium,
                      right: kPaddingMedium,
                      top: widget.topNavigationSize + kPaddingMedium,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: checkVideoLength ? kOpacityNone : kOpacityFull,
                          duration: kAnimationDurationRegular,
                          child: PositiveGlassSheet(
                            borderRadius: kBorderRadiusMedium,
                            horizontalPadding: kPaddingMedium,
                            verticalPadding: kPaddingExtraSmall,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    UniconsLine.exclamation_triangle,
                                    color: colours.white,
                                  ),
                                  const SizedBox(width: kPaddingSmall),
                                  Expanded(
                                    child: Text(
                                      localisations.page_create_post_clip_length_limit,
                                      style: typography.styleSubtitle.copyWith(color: colours.white),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-   Possible Video Export Loading Bar  -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    // ValueListenableBuilder(
                    //   valueListenable: _isExporting,
                    //   builder: (_, bool export, Widget? child) => AnimatedSize(
                    //     duration: kThemeAnimationDuration,
                    //     child: export ? child : null,
                    //   ),
                    //   child: AlertDialog(
                    //     title: ValueListenableBuilder(
                    //       valueListenable: _progress,
                    //       builder: (_, double value, __) => Text(
                    //         "Exporting video ${(value * 100).ceil()}%",
                    //         style: const TextStyle(fontSize: 12),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            //TODO
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _trimSlider() {
    return TrimSlider(
      controller: _controller,
      height: 50,
    );
  }
}

class ExportService {
  static Future<void> dispose() async {
    final executions = await FFmpegKit.listSessions();
    if (executions.isNotEmpty) await FFmpegKit.cancel();
  }

  static Future<FFmpegSession> runFFmpegCommand(
    FFmpegVideoEditorExecute execute, {
    required void Function(File file) onCompleted,
    void Function(Object, StackTrace)? onError,
    void Function(Statistics)? onProgress,
  }) {
    log('FFmpeg start process with command = ${execute.command}');
    return FFmpegKit.executeAsync(
      execute.command,
      (session) async {
        final state = FFmpegKitConfig.sessionStateToString(await session.getState());
        final code = await session.getReturnCode();

        if (code!.isValueSuccess()) {
          onCompleted(File(execute.outputPath));
        } else {
          if (onError != null) {
            onError(
              Exception('FFmpeg process exited with state $state and return code $code.\n${await session.getOutput()}'),
              StackTrace.current,
            );
          }
          return;
        }
      },
      null,
      onProgress,
    );
  }
}
