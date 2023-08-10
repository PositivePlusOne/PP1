// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reactions.freezed.dart';
part 'reactions.g.dart';

@freezed
class Reaction with _$Reaction {
  const factory Reaction({
    @Default('') String activityId,
    @Default('') String reactionId,
    @Default('') String senderId,
    @Default(ReactionType.unknownReaction()) @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson) ReactionType reactionType,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, dynamic> json) => _$ReactionFromJson(json);
}

@freezed
class ReactionType with _$ReactionType {
  const factory ReactionType.unknownReaction() = _ReactionTypeUnknownReaction;
  const factory ReactionType.like() = _ReactionTypeLike;
  const factory ReactionType.dislike() = _ReactionTypeDislike;
  const factory ReactionType.comment() = _ReactionTypeComment;

  factory ReactionType.fromJson(String json) {
    switch (json) {
      case 'like':
        return const ReactionType.like();
      case 'dislike':
        return const ReactionType.dislike();
      case 'comment':
        return const ReactionType.comment();
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
      default:
        return 'unknownReaction';
    }
  }
}
