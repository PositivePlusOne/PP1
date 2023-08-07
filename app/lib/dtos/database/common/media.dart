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

  static String getKey(Media media) {
    return media.bucketPath.isNotEmpty ? media.bucketPath : media.url;
  }

  factory Media.fromImageUrl(String url) {
    return Media(
      name: url,
      url: url,
      thumbnails: [],
      type: MediaType.photo_link,
      priority: kMediaPriorityDefault,
    );
  }

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

@freezed
class MediaThumbnail with _$MediaThumbnail {
  const factory MediaThumbnail({
    @Default('') String bucketPath,
    @Default('') String url,
    @Default(-1) int width,
    @Default(-1) int height,
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
  svg_link("svg_link"),
  video_link("video_link"),
  bucket_path("bucket_path");

  final String value;

  const MediaType(this.value);

  bool get isImage => this == MediaType.photo_link || this == MediaType.svg_link || this == MediaType.bucket_path;

  static MediaType fromMimeType(String mimeType, {bool storedInBucket = false}) {
    if (storedInBucket) {
      return MediaType.bucket_path;
    }

    switch (mimeType) {
      case 'image/jpeg':
      case 'image/png':
      case 'image/gif':
        return MediaType.photo_link;
      case 'image/svg+xml':
        return MediaType.svg_link;
      case 'video/mp4':
        return MediaType.video_link;
      default:
        return MediaType.unknown;
    }
  }
}
