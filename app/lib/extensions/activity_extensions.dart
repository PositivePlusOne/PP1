// Project imports:
import '../dtos/database/activities/activities.dart';
import '../dtos/database/common/media.dart';

extension ActivityExt on Activity {
  bool get hasContentToDisplay {
    final bool hasPublisher = publisherInformation?.foreignKey.isNotEmpty == true;
    final bool hasBodyContent = generalConfiguration?.content.isNotEmpty == true;
    final bool hasImageMedia = media.where((Media media) => media.type == MediaType.photo_link || media.type == MediaType.video_link).isNotEmpty;
    return hasPublisher && (hasBodyContent || hasImageMedia);
  }
}
