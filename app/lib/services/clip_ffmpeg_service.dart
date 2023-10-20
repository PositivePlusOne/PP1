import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:video_editor/video_editor.dart';
import 'dart:developer';

class CreateClipExportService {
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

  Future<void> exportVideoFromController(VideoEditorController controller, Function(File) onEndFunction) async {
    // _progress.value = 0;
    // isExporting(true);

    final config = VideoFFmpegVideoEditorConfig(
      controller,
      format: VideoExportFormat.mp4,
      // commandBuilder: (config, videoPath, outputPath) {
      //   final List<String> filters = config.getExportFilters();
      //   // filters.add('hflip'); // add horizontal flip

      //   return '-i $videoPath ${config.filtersCmd(filters)} $outputPath';
      // },
    );
    await runFFmpegCommand(
      await config.getExecuteConfig(),
      // onProgress: (stats) {
      //   _progress.value = config.getFFmpegProgress(stats.getTime().toInt());
      // },
      onError: (e, s) {},
      onCompleted: (file) {
        // isExporting(false);
        // if (!mounted) return;
        onEndFunction(file);
      },
    );
  }
}
