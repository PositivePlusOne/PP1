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
    @Default('') String path,
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
    @Default(ThumbnailType.none()) @JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson) ThumbnailType type,
    @Default('') String url,
  }) = _MediaThumbnail;

  static List<MediaThumbnail> fromJsonList(List<dynamic> data) {
    return data.map((e) => MediaThumbnail.fromJson(json.decodeSafe(e))).toList();
  }

  factory MediaThumbnail.fromJson(Map<String, dynamic> json) => _$MediaThumbnailFromJson(json);
}

@freezed
class ThumbnailType with _$ThumbnailType {
  const factory ThumbnailType.none() = _ThumbnailTypeNone;
  const factory ThumbnailType.small() = _ThumbnailTypeSmall;
  const factory ThumbnailType.medium() = _ThumbnailTypeMedium;
  const factory ThumbnailType.large() = _ThumbnailTypeLarge;

  static String toJson(ThumbnailType type) {
    return type.when(
      none: () => 'none',
      small: () => 'small',
      medium: () => 'medium',
      large: () => 'large',
    );
  }

  factory ThumbnailType.fromJson(String value) {
    switch (value) {
      case 'small':
        return const ThumbnailType.small();
      case 'medium':
        return const ThumbnailType.medium();
      case 'large':
        return const ThumbnailType.large();
      default:
        return const ThumbnailType.none();
    }
  }
}

extension ThumbnailTypeExtension on ThumbnailType {
  String get value {
    return when(
      none: () => '',
      small: () => '128x128',
      medium: () => '256x256',
      large: () => '512x512',
    );
  }
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
