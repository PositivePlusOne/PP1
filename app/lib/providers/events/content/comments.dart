// Project imports:
import '../../../dtos/database/activities/comments.dart';

class CommentCreatedEvent {
  const CommentCreatedEvent({
    required this.activityId,
    required this.comment,
  });

  final String activityId;
  final Comment comment;
}

class CommentUpdatedEvent {
  const CommentUpdatedEvent({
    required this.activityId,
    required this.comment,
  });

  final String activityId;
  final Comment comment;
}

class CommentDeletedEvent {
  const CommentDeletedEvent({
    required this.activityId,
    required this.commentId,
  });

  final String activityId;
  final String commentId;
}
