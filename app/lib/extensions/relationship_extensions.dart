import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:collection/collection.dart';

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
    final otherMember = members.firstWhereOrNull((m) => m.memberId != entityId);

    if (member == null || otherMember == null) {
      return {RelationshipState.targetBlocked, RelationshipState.sourceBlocked};
    }

    return {
      if (member.hasBlocked) RelationshipState.sourceBlocked,
      if (member.hasConnected) RelationshipState.sourceConnected,
      if (member.hasFollowed) RelationshipState.sourceFollowed,
      if (member.hasHidden) RelationshipState.sourceHidden,
      if (member.hasMuted) RelationshipState.sourceMuted,
      if (otherMember.hasBlocked) RelationshipState.targetBlocked,
      if (otherMember.hasConnected) RelationshipState.targetConnected,
      if (otherMember.hasFollowed) RelationshipState.targetFollowing,
      if (otherMember.hasHidden) RelationshipState.targetHidden,
      if (otherMember.hasMuted) RelationshipState.targetMuted,
    };
  }
}
