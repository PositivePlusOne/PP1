// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';

enum RelationshipState {
  targetBlocked,
  sourceBlocked,
  targetConnected,
  sourceConnected,
  targetFollowing,
  sourceFollowed,
  targetHidden,
  sourceHidden,
  targetMuted,
  sourceMuted,
}

extension RelationshipStateExt on Relationship {
  Set<RelationshipState> relationshipStatesForEntity(String entityId) {
    final member = members.firstWhereOrNull((m) => m.memberId == entityId);
    final otherMembers = members.where((element) => element.memberId != entityId);

    if (member == null || otherMembers.isEmpty) {
      return {RelationshipState.targetBlocked, RelationshipState.sourceBlocked};
    }

    return {
      if (member.hasBlocked) RelationshipState.sourceBlocked,
      if (member.hasConnected) RelationshipState.sourceConnected,
      if (member.hasFollowed) RelationshipState.sourceFollowed,
      if (member.hasHidden) RelationshipState.sourceHidden,
      if (member.hasMuted) RelationshipState.sourceMuted,
      if (otherMembers.any((element) => element.hasBlocked)) RelationshipState.targetBlocked,
      if (otherMembers.any((element) => element.hasConnected)) RelationshipState.targetConnected,
      if (otherMembers.any((element) => element.hasFollowed)) RelationshipState.targetFollowing,
      if (otherMembers.any((element) => element.hasHidden)) RelationshipState.targetHidden,
      if (otherMembers.any((element) => element.hasMuted)) RelationshipState.targetMuted,
    };
  }
}
