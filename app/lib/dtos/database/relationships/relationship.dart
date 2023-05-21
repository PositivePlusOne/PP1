// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship_member.dart';
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
    @Default('') String id,
    @Default(false) bool muted,
    @Default([]) List<RelationshipMember> members,
  }) = _Relationship;

  factory Relationship.empty() => const Relationship();

  factory Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);
}
