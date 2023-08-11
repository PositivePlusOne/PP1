// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'mentions.dart';

// Assuming you've already defined Mention and Media data classes somewhere.
// You might want to import them here, for example:
// import 'package:your_package_name/models/mention.dart';
// import 'package:your_package_name/models/media.dart';

part 'comments.freezed.dart';
part 'comments.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    @Default('') String content,
    @Default('') String reactionId,
    @Default('') String activityId,
    @Default('') String senderId,
    @Default([]) @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList) List<Mention> mentions,
    @Default([]) @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList) List<Media> media,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
