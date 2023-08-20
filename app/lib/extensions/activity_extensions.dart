// Project imports:
import 'package:app/providers/events/content/activities.dart';
import '../dtos/database/activities/activities.dart';
import '../dtos/database/common/media.dart';

extension ActivityExt on Activity {
  bool get hasContentToDisplay {
    final bool hasPublisher = publisherInformation?.foreignKey.isNotEmpty == true;
    final bool hasBodyContent = generalConfiguration?.content.isNotEmpty == true;
    final bool hasImageMedia = media.where((Media media) => media.type == MediaType.photo_link || media.type == MediaType.video_link).isNotEmpty;
    return hasPublisher && (hasBodyContent || hasImageMedia);
  }

  String get shortDescription {
    return generalConfiguration?.content.isNotEmpty == true ? generalConfiguration!.content : '';
  }

  List<TargetFeed> get tagTargetFeeds {
    final List<TargetFeed> targetFeeds = <TargetFeed>[];
    if (enrichmentConfiguration?.tags != null) {
      for (final String tag in enrichmentConfiguration!.tags) {
        targetFeeds.add(TargetFeed('tag', tag));
      }
    }

    return targetFeeds;
  }
}
