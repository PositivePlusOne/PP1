// Package imports:
// ignore_for_file: constant_identifier_names

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/extensions/json_extensions.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@freezed
class Media with _$Media {
  const factory Media({
    @Default('') String name,
    @Default('') String bucketPath,
    @Default('') String url,
    @Default([]) List<MediaThumbnail> thumbnails,
    @Default(MediaType.unknown) MediaType type,
    @Default(kMediaPriorityDefault) int priority,
    @Default(false) isSensitive,
    @Default(false) isPrivate,
  }) = _Media;

  static List<Media> fromJsonList(List<dynamic> data) {
    return data.map((e) => Media.fromJson(json.decodeSafe(e))).toList();
  }

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

@freezed
class MediaThumbnail with _$MediaThumbnail {
  const factory MediaThumbnail({
    @Default('') String bucketPath,
    @Default('') String url,
  }) = _MediaThumbnail;

  static List<MediaThumbnail> fromJsonList(List<dynamic> data) {
    return data.map((e) => MediaThumbnail.fromJson(json.decodeSafe(e))).toList();
  }

  factory MediaThumbnail.fromJson(Map<String, dynamic> json) => _$MediaThumbnailFromJson(json);
}

const kMediaPriorityMax = 0;
const kMediaPriorityDefault = 1000;

enum MediaType {
  unknown("unknown"),
  website_link("website_link"),
  ticket_link("ticket_link"),
  photo_link("photo_link"),
  video_link("video_link"),
  bucket_path("bucket_path");

  final String value;

  const MediaType(this.value);
}
