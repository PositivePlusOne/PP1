// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@freezed
class MediaDto with _$MediaDto {
  const factory MediaDto({
    required MediaType type,
    required String url,
    required int priority,
  }) = _MediaDto;

  static List<MediaDto> fromJsonList(List<dynamic> json) {
    return json.map((e) => MediaDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  factory MediaDto.fromJson(Map<String, dynamic> json) => _$MediaDtoFromJson(json);
}

const kMediaPriorityMax = 0;
const kMediaPriorityDefault = 1000;

enum MediaType {
  websiteLink("website_link"),
  ticketLink("ticket_link"),
  photoLink("photo_link"),
  videoLink("video_link");

  final String value;

  const MediaType(this.value);
}
