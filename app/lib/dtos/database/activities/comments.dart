// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/common/media.dart';
import 'mentions.dart';

part 'comments.freezed.dart';
part 'comments.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String data,
    @Default('') @JsonKey(name: 'reaction_id') String reactionId,
    @Default('') @JsonKey(name: 'activity_id') String activityId,
    @Default('') @JsonKey(name: 'user_id') userId,
    @Default([]) @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList) List<Mention> mentions,
    @Default([]) @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList) List<Media> media,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
