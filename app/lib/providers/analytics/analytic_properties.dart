// Project imports:
import 'package:app/dtos/database/activities/activities.dart';

const String sourceKey = 'source';

const String postIdKey = 'postId';
const String postOriginKey = 'postOrigin';
const String searchTermKey = 'searchTerm';
const String containsMediaKey = 'containsMedia';
const String viewPermissionsKey = 'viewPermissions';
const String commentPermissionsKey = 'commentPermissions';
const String sharePermissionsKey = 'sharePermissions';

enum AnalyticSource {
  post,
  search;

  String get locale {
    switch (this) {
      case AnalyticSource.post:
        return 'Post';
      case AnalyticSource.search:
        return 'Search';
    }
  }
}

bool propertiesSourcedFromPost(Map<String, Object?> properties) {
  return properties.containsKey(sourceKey) && properties[sourceKey] == AnalyticSource.post.locale;
}

bool propertiesSourcedFromSearch(Map<String, Object?> properties) {
  return properties.containsKey(sourceKey) && properties[sourceKey] == AnalyticSource.search.locale;
}

Map<String, Object?> generatePropertiesForPostSource({
  Activity? activity,
  String? searchTerm,
}) {
  final String postId = activity?.flMeta?.id ?? '';
  final String origin = activity?.publisherInformation?.originFeed ?? '';
  if (postId.isEmpty || origin.isEmpty) {
    return {};
  }

  return {
    sourceKey: AnalyticSource.post.locale,
    postIdKey: postId,
    postOriginKey: origin,
    searchTermKey: searchTerm,
    containsMediaKey: activity?.media.isNotEmpty,
    viewPermissionsKey: activity?.securityConfiguration?.viewMode,
    commentPermissionsKey: activity?.securityConfiguration?.commentMode,
    sharePermissionsKey: activity?.securityConfiguration?.shareMode,
  };
}

Map<String, Object?> generatePropertiesForSearchSource(String searchTerm) {
  return {
    sourceKey: AnalyticSource.search.locale,
    searchTermKey: searchTerm,
  };
}
