// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/string_extensions.dart';
import '../common/fl_meta.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

@freezed
class Relationship with _$Relationship {
  const factory Relationship({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default(false) bool blocked,
    @Default('') String channelId,
    @Default(false) bool connected,
    @Default(false) bool following,
    @Default(false) bool hidden,
    @Default(false) bool muted,
    @Default([]) List<RelationshipMember> members,
  }) = _Relationship;

  factory Relationship.empty(List<String> members) {
    return Relationship(
      flMeta: FlMeta.empty(members.asGUID, 'relationships'),
      members: members.where((element) => element.isNotEmpty).map((String memberId) => RelationshipMember(memberId: memberId)).toList(),
    );
  }

  factory Relationship.owner(List<String> members) {
    return Relationship(
      flMeta: FlMeta.empty(members.asGUID, 'relationships'),
      members: members.map((e) => RelationshipMember.owner(e)).toList(),
      channelId: '',
      connected: true,
      following: true,
      blocked: false,
      hidden: false,
      muted: false,
    );
  }

  factory Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);
}
