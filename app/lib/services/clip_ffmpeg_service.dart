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

    final config = VideoFFmpegVideoEditorConfig(
      controller,
      format: VideoExportFormat.mp4,
    );
    await runFFmpegCommand(
      await config.getExecuteConfig(),
      onError: (e, s) {},
      onCompleted: (file) {
        onEndFunction(file);
      },
    );
  }
}
