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
    @Default([]) List<RelationshipMember> members,
    @Default([]) @JsonKey(fromJson: RelationshipFlag.fromJsonList, toJson: RelationshipFlag.toJsonList) List<RelationshipFlag> flags,
    @Default(false) bool blocked,
    @Default('') String channelId,
    @Default(false) bool connected,
    @Default(false) bool following,
    @Default(false) bool hidden,
    @Default(false) bool muted,
    @Default(false) bool managed,
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

@freezed
class RelationshipFlag with _$RelationshipFlag {
  const factory RelationshipFlag.organisationManager() = _RelationshipFlagOrganisationManager;

  static String toJson(RelationshipFlag strategy) {
    return strategy.when(
      organisationManager: () => 'organisation_manager',
    );
  }

  static List<String> toJsonList(List<RelationshipFlag> strategies) {
    return strategies.map((e) => toJson(e)).toList();
  }

  factory RelationshipFlag.fromJson(dynamic value) {
    switch (value) {
      case 'organisation_manager':
        return const _RelationshipFlagOrganisationManager();
      default:
        throw ArgumentError('Invalid value for ActivityPricingExternalStoreInformationPricingStrategy: $value');
    }
  }

  static List<RelationshipFlag> fromJsonList(List<dynamic> json) {
    return json.map((e) => RelationshipFlag.fromJson(e)).toList();
  }
}
