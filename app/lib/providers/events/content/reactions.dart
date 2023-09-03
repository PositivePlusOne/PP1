import 'package:app/dtos/database/activities/reactions.dart';

class ReactionCreatedEvent {
  const ReactionCreatedEvent({
    required this.activityId,
    required this.reaction,
  });

  final String activityId;
  final Reaction reaction;
}

class ReactionUpdatedEvent {
  const ReactionUpdatedEvent({
    required this.activityId,
    required this.reaction,
  });

  final String activityId;
  final Reaction reaction;
}

class ReactionDeletedEvent {
  const ReactionDeletedEvent({
    required this.activityId,
    required this.reactionId,
  });

  final String activityId;
  final String reactionId;
}
