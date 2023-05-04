// Package imports:
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Called when a new activity is added to a feed
// For example, when a user posts a new status update
class ActivityAddedEvent {
  ActivityAddedEvent(this.activity);
  final GenericEnrichedActivity<User, String, String, String> activity;
}
