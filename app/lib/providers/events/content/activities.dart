// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';

class TargetFeed {
  TargetFeed(this.feed, this.slug);

  static TargetFeed fromTag(Tag tag) => TargetFeed('tags', tag.key);

  final String feed;
  final String slug;
}

class ActivityCreatedEvent {
  const ActivityCreatedEvent({
    required this.targets,
    required this.activity,
  });

  final List<TargetFeed> targets;
  final Activity activity;
}

class ActivityUpdatedEvent {
  const ActivityUpdatedEvent({
    required this.targets,
    required this.activity,
  });

  final List<TargetFeed> targets;
  final Activity activity;
}

class ActivityDeletedEvent {
  const ActivityDeletedEvent({
    required this.targets,
    required this.activityId,
  });

  final List<TargetFeed> targets;
  final String activityId;
}
