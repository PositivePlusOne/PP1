import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';

Relationship buildDefaultRelationship(List<String> members) {
  return Relationship(
    id: '',
    channelId: '',
    blocked: true,
    connected: false,
    following: false,
    hidden: true,
    muted: true,
    members: members
        .map(
          (e) => RelationshipMember(
            memberId: e,
            hasBlocked: true,
            hasConnected: false,
            hasFollowed: false,
            hasHidden: true,
            hasMuted: true,
          ),
        )
        .toList(),
  );
}
