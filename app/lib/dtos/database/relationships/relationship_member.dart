// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_member.freezed.dart';
part 'relationship_member.g.dart';

@freezed
class RelationshipMember with _$RelationshipMember {
  const factory RelationshipMember({
    @Default(false) bool hasBlocked,
    @Default(false) bool hasConnected,
    @Default(false) bool hasFollowed,
    @Default(false) bool hasHidden,
    @Default(false) bool hasMuted,
    @Default('') String memberId,
  }) = _RelationshipMember;

  factory RelationshipMember.empty() => const RelationshipMember();

  factory RelationshipMember.owner(String id) => RelationshipMember(
        hasConnected: true,
        hasFollowed: true,
        hasBlocked: false,
        hasHidden: false,
        hasMuted: false,
        memberId: id,
      );

  factory RelationshipMember.fromJson(Map<String, dynamic> json) => _$RelationshipMemberFromJson(json);
}
