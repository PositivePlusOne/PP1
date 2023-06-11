// Project imports:
import '../dtos/database/activities/activities.dart';
import '../dtos/database/common/media.dart';

extension ActivityExt on Activity {
  bool get hasContentToDisplay {
    final bool hasBodyContent = generalConfiguration?.content.isNotEmpty == true;
    final bool hasImageMedia = media.where((MediaDto media) => media.type == MediaType.photo_link || media.type == MediaType.video_link).isNotEmpty;
    return hasBodyContent || hasImageMedia;
  }
}
