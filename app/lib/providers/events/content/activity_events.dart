// Project imports:
import 'package:app/dtos/database/activities/tags.dart';

class TargetFeed {
  TargetFeed(this.feed, this.slug);

  static TargetFeed fromTag(Tag tag) => TargetFeed('tags', tag.key);

  static TargetFeed fromOrigin(String origin) {
    final List<String> parts = origin.split(':');
    final String feed = parts[0];
    final String slug = parts[1];

    return TargetFeed(feed, slug);
  }

  static String toOrigin(TargetFeed targetFeed) {
    String feed = targetFeed.feed;

    //! If we have more aggregated feeds, we need to add them here
    if (feed == 'timeline') {
      feed = 'user';
    }

    return '$feed:${targetFeed.slug}';
  }

  final String feed;
  final String slug;
}
