// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/media_information.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/media_information_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/stream_information.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_editor/video_editor.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

part 'clip_ffmpeg_service.g.dart';

@Riverpod(keepAlive: true)
CreateClipExportService createClipExportService(CreateClipExportServiceRef ref) {
  return CreateClipExportService();
}

class CreateClipExportService {
  // TODO: Add a dispose method to cancel all ffmpeg executions
  Future<void> dispose() async {
    final executions = await FFmpegKit.listSessions();
    if (executions.isNotEmpty) await FFmpegKit.cancel();
  }

  Future<Size> getVideoSize(File file) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final MediaInformationSession response = await FFprobeKit.getMediaInformation(file.path);
    final MediaInformation? info = response.getMediaInformation();

    if (info == null) {
      logger.e('getVideoSize() failed to get video metadata');
      throw Exception('getVideoSize() failed to get video metadata');
    }

    final List<StreamInformation> streams = info.getStreams();

    // One of the streams will be video, check each one until we find it (height + width)
    int height = 0;
    int width = 0;
    for (final StreamInformation stream in streams) {
      final streamHeight = stream.getHeight();
      final streamWidth = stream.getWidth();

      if (streamHeight != null && streamWidth != null) {
        height = streamHeight;
        width = streamWidth;
        break;
      }
    }

    if (height == 0 || width == 0) {
      logger.e('getVideoSize() failed to get video size');
      throw Exception('getVideoSize() failed to get video size');
    }

    return Size(width.toDouble(), height.toDouble());
  }

  Future<File> exportVideoFromController(VideoEditorController controller) async {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('Clamping video to 720p mp4');
    //TODO, currently making our own args list instead of using the generator, possible to remove this later/create our own
    final config = VideoFFmpegVideoEditorConfig(controller, format: VideoExportFormat.mp4);

    // Split '-y -i $videoPath -vf scale=-2:720 -c:v libx264 -preset medium -c:a aac -b:a 128k $outputPath' in to a list of arguments
    final String videoPath = controller.file.path;
    final String outputPath = await config.getOutputPath(
      filePath: videoPath,
      format: config.format,
    );

    final List<String> args = <String>[
      //? overwrite duplicates
      '-y',
      //? input
      '-i',
      videoPath,
      //? Trim from point in time
      "-ss",
      controller.startTrim.toString(),
      //? Trim to point in time
      "-to",
      controller.endTrim.toString(),
      //? Set output format to libx264
      "-c:v",
      "libx264",
      //? Use fast processor
      "-preset",
      "ultrafast",
      //? Filter to downscale
      "-vf",
      "scale=-2:720",
      //! Cannot find documentation on -crf?
      "-crf",
      "32",
      //? copy audio stream and reencode to aac codec
      "-c:a",
      "aac",
      //? sample bitrate down to 44,100
      "-b:a",
      "44100",
      //? Output path
      outputPath,
    ];

    bool isComplete = false;
    final FFmpegSession session = await FFmpegKit.executeWithArgumentsAsync(
      args,
      (session) {
        isComplete = true;
      },
    );

    int i = 0;
    while (!isComplete) {
      await Future.delayed(const Duration(milliseconds: 100));
      i++;
      if (i > 10 * 60 * 10) {
        logger.e('exportVideoFromController() ffmpeg failed to complete');
        throw Exception('exportVideoFromController() ffmpeg failed to complete');
      }
    }

    final SessionState state = await session.getState();

    if (state == SessionState.failed) {
      final ReturnCode? returnCode = await session.getReturnCode();
      final String? output = await session.getOutput();
      final List<Log> logs = await session.getLogs();

      logger.e('exportVideoFromController() ffmpeg failed: $returnCode\n$output\n$logs');
      throw Exception('exportVideoFromController() ffmpeg failed: $returnCode\n$output\n$logs');
    }

    final File file = File(outputPath);

    i = 0;
    int previousSize = 0;
    while (true) {
      if (!(await file.exists())) {
        await Future.delayed(const Duration(milliseconds: 100));
        i++;
        if (i > 100) {
          logger.e('exportVideoFromController() ffmpeg failed to create file');
          throw Exception('exportVideoFromController() ffmpeg failed to create file');
        }
      } else {
        final int currentSize = await file.length();
        if (currentSize == previousSize) {
          // File size is not changing, assume writing is done
          break;
        }

        previousSize = currentSize;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    logger.d('exportVideoFromController() ffmpeg succeeded');
    return File(outputPath);
  }
}
