// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reactions.freezed.dart';
part 'reactions.g.dart';

@freezed
class Reaction with _$Reaction {
  const factory Reaction({
    @Default('') @JsonKey(name: 'activity_id') String activityId,
    @Default('') @JsonKey(name: 'reaction_id') String reactionId,
    @Default('') @JsonKey(name: 'user_id') String userId,
    @Default(ReactionType.unknownReaction()) @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson) ReactionType kind,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, dynamic> json) => _$ReactionFromJson(json);
}

@freezed
class ReactionType with _$ReactionType {
  const factory ReactionType.unknownReaction() = _ReactionTypeUnknownReaction;
  const factory ReactionType.like() = _ReactionTypeLike;
  const factory ReactionType.dislike() = _ReactionTypeDislike;
  const factory ReactionType.comment() = _ReactionTypeComment;
  const factory ReactionType.bookmark() = _ReactionTypeComment;

  factory ReactionType.fromJson(String json) {
    switch (json) {
      case 'like':
        return const ReactionType.like();
      case 'dislike':
        return const ReactionType.dislike();
      case 'comment':
        return const ReactionType.comment();
      case 'bookmark':
        return const ReactionType.bookmark();
      default:
        return const ReactionType.unknownReaction();
    }
  }

  static String toJson(ReactionType reactionType) {
    switch (reactionType) {
      case ReactionType.like:
        return 'like';
      case ReactionType.dislike:
        return 'dislike';
      case ReactionType.comment:
        return 'comment';
      case ReactionType.bookmark:
        return 'bookmark';
      default:
        return 'unknownReaction';
    }
  }
}
