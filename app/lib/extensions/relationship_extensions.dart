// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';

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
  targetManaged,
  sourceManaged,
  fullyConnected,
}

extension RelationshipStateExt on Relationship {
  bool get isFullyConnected {
    return members.every((element) => element.hasConnected);
  }

  bool get hasHiddenPostsOfTarget {
    final String? currentUserId = providerContainer.read(profileControllerProvider.select((value) => value.currentProfile?.flMeta?.id));
    if (currentUserId == null) {
      return false;
    }

    return members.firstWhereOrNull((element) => element.memberId == currentUserId)?.hasHidden ?? false;
  }

  Set<RelationshipState> relationshipStatesForEntity(String entityId) {
    final member = members.firstWhereOrNull((m) => m.memberId == entityId);
    final otherMembers = members.where((m) => m.memberId != entityId);

    if (member == null || otherMembers.isEmpty) {
      return {};
    }

    return {
      if (member.hasBlocked) RelationshipState.sourceBlocked,
      if (member.hasConnected) RelationshipState.sourceConnected,
      if (member.hasFollowed) RelationshipState.sourceFollowed,
      if (member.hasHidden) RelationshipState.sourceHidden,
      if (member.hasMuted) RelationshipState.sourceMuted,
      if (member.canManage) RelationshipState.sourceManaged,
      if (otherMembers.any((element) => element.hasBlocked)) RelationshipState.targetBlocked,
      if (otherMembers.any((element) => element.hasConnected)) RelationshipState.targetConnected,
      if (otherMembers.any((element) => element.hasFollowed)) RelationshipState.targetFollowing,
      if (otherMembers.any((element) => element.hasHidden)) RelationshipState.targetHidden,
      if (otherMembers.any((element) => element.hasMuted)) RelationshipState.targetMuted,
      if (otherMembers.any((element) => element.canManage)) RelationshipState.targetManaged,
      if (member.hasConnected && otherMembers.any((element) => element.hasConnected)) RelationshipState.fullyConnected,
    };
  }

  // Returns true if all members have connected
  bool get hasMembers => members.isNotEmpty;
  bool get isValidConnectedRelationship {
    final bool isDirect = members.length == 2;
    if (isDirect) {
      return members.every((m) => m.hasConnected);
    }

    return true;
  }
}
