// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';

const String sourceKey = 'source';

const String postIdKey = 'postId';
const String postOriginKey = 'postOrigin';
const String searchTermKey = 'searchTerm';

const String containsMediaKey = 'containsMedia';
const String containsMentionsKey = 'containsMentions';
const String containsTagsKey = 'containsTags';

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

  final String postContent = activity?.generalConfiguration?.content ?? '';
  final bool containsTag = activity?.enrichmentConfiguration?.tags.any((element) => !TagHelpers.isReserved(element)) ?? false;
  final bool containsMention = PositiveTextFieldState.findMentions(postContent).isNotEmpty;

  return {
    sourceKey: AnalyticSource.post.locale,
    postIdKey: postId,
    postOriginKey: origin,
    searchTermKey: searchTerm,
    containsMediaKey: activity?.media.isNotEmpty,
    viewPermissionsKey: ActivitySecurityConfigurationMode.toJson(activity?.securityConfiguration?.viewMode),
    commentPermissionsKey: ActivitySecurityConfigurationMode.toJson(activity?.securityConfiguration?.commentMode),
    sharePermissionsKey: ActivitySecurityConfigurationMode.toJson(activity?.securityConfiguration?.shareMode),
    containsTagsKey: containsTag,
    containsMentionsKey: containsMention,
  };
}

Map<String, Object?> generatePropertiesForSearchSource(String searchTerm) {
  return {
    sourceKey: AnalyticSource.search.locale,
    searchTermKey: searchTerm,
  };
}
