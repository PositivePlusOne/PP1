// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';

class RelationshipUpdatedEvent {
  RelationshipUpdatedEvent(this.relationship);

  final Relationship? relationship;
}
