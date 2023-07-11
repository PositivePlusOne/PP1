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
class MediaDto with _$MediaDto {
  const factory MediaDto({
    @Default(MediaType.unknown) MediaType type,
    @Default('') String url,
    @Default(kMediaPriorityDefault) int priority,
  }) = _MediaDto;

  static List<MediaDto> fromJsonList(List<dynamic> data) {
    return data.map((e) => MediaDto.fromJson(json.decodeSafe(e))).toList();
  }

  factory MediaDto.fromJson(Map<String, dynamic> json) => _$MediaDtoFromJson(json);
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
