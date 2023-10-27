// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
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

    logger.d('Getting video size');
    final List<String> args = <String>[
      '-i',
      file.path,
    ];

    final FFmpegSession session = await FFmpegKit.executeWithArgumentsAsync(args);
    final SessionState state = await session.getState();

    if (state == SessionState.failed) {
      final ReturnCode? returnCode = await session.getReturnCode();
      final String? output = await session.getOutput();
      final List<Log> logs = await session.getLogs();

      logger.e('getVideoSize() ffmpeg failed: $returnCode\n$output\n$logs');
      throw Exception('getVideoSize() ffmpeg failed: $returnCode\n$output\n$logs');
    }

    final String? output = await session.getOutput();
    final List<Log> logs = await session.getLogs();

    logger.d('getVideoSize() ffmpeg succeeded: $output\n$logs');

    // Updated regular expression
    final RegExp regExp = RegExp(r'Video: h264.*?,.*?(\d+)x(\d+)[,\s]');
    final Match? match = regExp.firstMatch(output!);
    if (match == null || match.groupCount < 2) {
      logger.e('getVideoSize() failed to get video size');
      throw Exception('getVideoSize() failed to get video size');
    }

    // Using group(1) for width and group(2) for height
    final double width = double.parse(match.group(1)!);
    final double height = double.parse(match.group(2)!);

    return Size(width, height);
  }

  Future<File> exportVideoFromController(VideoEditorController controller) async {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('Clamping video to 720p mp4');
    final config = VideoFFmpegVideoEditorConfig(controller, format: VideoExportFormat.mp4);

    // Split '-y -i $videoPath -vf scale=-2:720 -c:v libx264 -preset medium -c:a aac -b:a 128k $outputPath' in to a list of arguments
    final String videoPath = controller.file.path;
    final String outputPath = await config.getOutputPath(
      filePath: videoPath,
      format: config.format,
    );

    final List<String> args = <String>[
      '-y',
      '-i',
      videoPath,
      "-af",
      "highpass=f=200, lowpass=f=3000,afftdn",
      "-c:v",
      "libx264",
      "-preset",
      "fast",
      "-crf",
      "28",
      "-c:a",
      "aac",
      "-b:a",
      "44100",
      outputPath,
    ];

    bool isComplete = false;
    final FFmpegSession session = await FFmpegKit.executeWithArgumentsAsync(args, (session) {
      isComplete = true;
    });

    int i = 0;
    while (!isComplete) {
      await Future.delayed(const Duration(milliseconds: 100));
      i++;
      if (i > 100) {
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
