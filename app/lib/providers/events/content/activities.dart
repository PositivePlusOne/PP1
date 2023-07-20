// Project imports:
import 'package:app/dtos/database/activities/activities.dart';

class ActivityCreatedEvent {
  const ActivityCreatedEvent({
    required this.feed,
    required this.slug,
    required this.activity,
  });

  final String feed;
  final String slug;
  final Activity activity;
}

class ActivityUpdatedEvent {
  const ActivityUpdatedEvent({
    required this.feed,
    required this.slug,
    required this.activity,
  });

  final String feed;
  final String slug;
  final Activity activity;
}

class ActivityDeletedEvent {
  const ActivityDeletedEvent({
    required this.feed,
    required this.slug,
    required this.activity,
  });

  final String feed;
  final String slug;
  final Activity activity;
}
