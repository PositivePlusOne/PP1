const String sourceKey = 'source';

const String postIdKey = 'postId';
const String postOriginKey = 'postOrigin';
const String searchTermKey = 'searchTerm';

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

Map<String, Object?> generatePropertiesForPostSource(
  String postId,
  String origin, {
  String searchTerm = '',
}) {
  if (postId.isEmpty || origin.isEmpty) {
    return {};
  }

  return {
    sourceKey: AnalyticSource.post.locale,
    postIdKey: postId,
    postOriginKey: origin,
    searchTermKey: searchTerm,
  };
}

Map<String, Object?> generatePropertiesForSearchSource(String searchTerm) {
  return {
    sourceKey: AnalyticSource.search.locale,
    searchTermKey: searchTerm,
  };
}
