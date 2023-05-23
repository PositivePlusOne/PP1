// Package imports:
// ignore_for_file: constant_identifier_names

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@freezed
class MediaDto with _$MediaDto {
  const factory MediaDto({
    @Default(MediaType.unknown) MediaType type,
    @Default('') String url,
    @Default(kMediaPriorityDefault) int priority,
  }) = _MediaDto;

  static List<MediaDto> fromJsonList(List<dynamic> json) {
    return json.map((e) => MediaDto.fromJson(e as Map<String, dynamic>)).toList();
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
  video_link("video_link");

  final String value;

  const MediaType(this.value);
}
