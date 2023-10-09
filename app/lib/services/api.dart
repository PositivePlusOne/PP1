// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/report_type.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';

part 'api.g.dart';

Map<String, dynamic> buildRequestPayload({
  required String name,
  String? sender,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
}) {
  final Map<String, dynamic> requestPayload = <String, dynamic>{
    'name': name,
    'sender': sender,
    'cursor': pagination?.cursor,
    'limit': pagination?.limit,
    'data': {
      ...parameters,
    }
  };

  return requestPayload;
}

bool canChangeTargetId(String name) {
  return switch (name) {
    'system-getSystemConfiguration' => false,
    'profile-updateFcmToken' => false,
    (_) => true,
  };
}

FutureOr<T> getHttpsCallableResult<T>({
  required String name,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
  T Function(EndpointResponse response)? selector,
}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final FirebaseFunctions firebaseFunctions = providerContainer.read(firebaseFunctionsProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  final FirebasePerformance firebasePerformance = providerContainer.read(firebasePerformanceProvider);
  final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

  final String currentUid = firebaseAuth.currentUser?.uid ?? '';
  final String targetUid = profileController.currentProfileId ?? '';
  final bool canChangeTarget = canChangeTargetId(name) && targetUid.isNotEmpty;
  final String selectedUid = canChangeTarget ? targetUid : currentUid;
  final Trace trace = firebasePerformance.newTrace(name);
  final Stopwatch stopwatch = Stopwatch();

  logger.d('getHttpsCallableResult: $name, $pagination, $parameters');
  if (currentUid.isNotEmpty && targetUid.isNotEmpty && currentUid != targetUid) {
    logger.i('getHttpsCallableResult: Target uid is not current uid');
    logger.i('getHttpsCallableResult: $currentUid -> $targetUid');
  }

  final requestPayload = buildRequestPayload(
    name: name,
    sender: selectedUid,
    pagination: pagination,
    parameters: parameters,
  );

  try {
    trace.start();
    stopwatch.start();

    final HttpsCallableResult response = await firebaseFunctions.httpsCallable(name).call(requestPayload);
    Map<String, dynamic> responseData = json.decodeSafe(response.data);

    final EndpointResponse responsePayload = EndpointResponse.fromJson(responseData);
    if (responsePayload.data.isNotEmpty) {
      providerContainer.cacheResponseData(responsePayload.data);
    }

    if (selector == null) {
      return responsePayload as T;
    }

    return selector(responsePayload);
  } catch (e) {
    logger.e('getHttpsCallableResult: $e');
    rethrow;
  } finally {
    trace.stop();
    stopwatch.stop();
    logger.d('getHttpsCallableResult: $name took ${stopwatch.elapsedMilliseconds}ms');
  }
}

@Riverpod(keepAlive: true)
FutureOr<SystemApiService> systemApiService(SystemApiServiceRef ref) async {
  return SystemApiService();
}

class SystemApiService {
  FutureOr<EndpointResponse> getSystemConfiguration() async {
    return await getHttpsCallableResult(
      name: 'system-getSystemConfiguration',
    );
  }

  FutureOr<String> getStreamToken() async {
    return await getHttpsCallableResult<String>(
      name: 'system-getStreamToken',
      selector: (response) => response.data['token'].toString(),
    );
  }

  FutureOr<EndpointResponse> submitFeedback({
    required String content,
    required FeedbackType feedbackType,
    required ReportType reportType,
  }) async {
    return await getHttpsCallableResult(
      name: 'system-submitFeedback',
      parameters: {
        'content': content,
        'feedbackType': FeedbackType.toJson(feedbackType),
        'reportType': ReportType.toJson(reportType),
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<PostApiService> postApiService(PostApiServiceRef ref) async {
  return PostApiService();
}

class PostApiService {
  FutureOr<Map<String, Object?>> getActivity({
    required String entryId,
  }) async {
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'post-getActivity',
      selector: (response) => json.decodeSafe((response.data['activities'] as Iterable).first),
      parameters: {
        'entry': entryId,
      },
    );
  }

  FutureOr<Activity> postActivity({
    required ActivityData activityData,
  }) async {
    late String type;
    switch (activityData.postType) {
      case PostType.clip:
        type = 'clip';
        break;
      case PostType.repost:
        type = 'repost';
        break;
      case PostType.event:
        type = 'event';
        break;

      case PostType.text:
      case PostType.image:
      case PostType.multiImage:
      default:
        type = 'post';
        break;
    }
    final List<Media> media = activityData.media ?? const [];

    return await getHttpsCallableResult<Activity>(
      name: 'post-postActivity',
      selector: (response) => Activity.fromJson(json.decodeSafe((response.data['activities'] as Iterable).first)),
      parameters: {
        'content': activityData.content ?? "",
        'tags': activityData.tags ?? [],
        'media': media.map((e) => e.toJson()).toList(),
        'style': 'text',
        'type': type,
        'allowSharing': activityData.allowSharing ?? false,
        'visibleTo': ActivitySecurityConfigurationMode.toJson(activityData.visibilityMode ?? const ActivitySecurityConfigurationMode.followersAndConnections()),
        'allowComments': ActivitySecurityConfigurationMode.toJson(activityData.commentPermissionMode ?? const ActivitySecurityConfigurationMode.followersAndConnections()),
        'allowLikes': ActivitySecurityConfigurationMode.toJson(const ActivitySecurityConfigurationMode.public()),
        'allowBookmarks': ActivitySecurityConfigurationMode.toJson(const ActivitySecurityConfigurationMode.public()),
      },
    );
  }

  FutureOr<Activity> updateActivity({
    required ActivityData activityData,
  }) async {
    final List<Media> media = activityData.media ?? const [];

    return await getHttpsCallableResult<Activity>(
      name: 'post-updateActivity',
      selector: (response) => Activity.fromJson(json.decodeSafe((response.data['activities'] as Iterable).first)),
      parameters: {
        'content': activityData.content ?? "",
        'tags': activityData.tags ?? [],
        'media': media.map((e) => e.toJson()).toList(),
        'postId': activityData.activityID ?? "",
        'allowSharing': activityData.allowSharing ?? false,
        'visibleTo': ActivitySecurityConfigurationMode.toJson(activityData.visibilityMode ?? const ActivitySecurityConfigurationMode.followersAndConnections()),
        'allowComments': ActivitySecurityConfigurationMode.toJson(activityData.commentPermissionMode ?? const ActivitySecurityConfigurationMode.followersAndConnections()),
        'allowLikes': ActivitySecurityConfigurationMode.toJson(const ActivitySecurityConfigurationMode.public()),
        'allowBookmarks': ActivitySecurityConfigurationMode.toJson(const ActivitySecurityConfigurationMode.public()),
      },
    );
  }

  FutureOr<EndpointResponse> deleteActivity({
    required String activityId,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-deleteActivity',
      parameters: {
        'activityId': activityId,
      },
    );
  }

  FutureOr<EndpointResponse> listActivities({
    required String targetSlug,
    required String targetUserId,
    Pagination? pagination,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-listActivities',
      pagination: pagination,
      parameters: {
        'targetSlug': targetSlug,
        'targetUserId': targetUserId,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<ProfileApiService> profileApiService(ProfileApiServiceRef ref) async {
  return ProfileApiService();
}

class ProfileApiService {
  FutureOr<List<Map<String, Object?>>> getProfiles({
    Iterable<String> members = const [],
  }) async {
    return await getHttpsCallableResult<List<Map<String, Object?>>>(
      name: 'profile-getProfiles',
      selector: (response) => (response.data['users'] as List).map((e) => json.decodeSafe(e)).toList(),
      parameters: {
        'targets': members.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> getProfile({
    required String uid,
  }) async {
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-getProfile',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == uid)),
      parameters: {
        'uid': uid,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateFcmToken({
    required String fcmToken,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateFcmToken',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'fcmToken': fcmToken,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateEmailAddress({
    required String emailAddress,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateEmailAddress',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'emailAddress': emailAddress,
      },
    );
  }

  FutureOr<Map<String, Object?>> updatePhoneNumber({
    required String phoneNumber,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updatePhoneNumber',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'phoneNumber': phoneNumber,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateName({
    required String name,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateName',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'name': name,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateDisplayName({
    required String displayName,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateDisplayName',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'displayName': displayName,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateBirthday({
    required String birthday,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateBirthday',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'birthday': birthday,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateInterests({
    required List<String> interests,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateInterests',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'interests': interests,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateHivStatus({
    required String hivStatus,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateHivStatus',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'status': hivStatus,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateGenders({
    required List<String> genders,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateGenders',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'genders': genders,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateCompanySectors({
    required List<String> companySectors,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateCompanySectors',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'companySectors': companySectors,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updatePlace({
    required String description,
    required String placeId,
    required double latitude,
    required double longitude,
    bool optOut = false,
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updatePlace',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'optOut': optOut,
        'description': description,
        'placeId': placeId,
        'latitude': latitude,
        'longitude': longitude,
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateBiography({
    required String biography,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateBiography',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'biography': biography,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateAccentColor({
    required String accentColor,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateAccentColor',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'accentColor': accentColor,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateFeatureFlags({
    required Set<String> featureFlags,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateFeatureFlags',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'featureFlags': featureFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateVisibilityFlags({
    required Set<String> visibilityFlags,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateVisibilityFlags',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> addMedia({
    required List<Media> media,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    final List<Map<String, Object?>> mediaList = media.map((e) => e.toJson()).toList();
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-addMedia',
      selector: (response) => json.decodeSafe((response.data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'media': mediaList,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<RelationshipApiService> relationshipApiService(RelationshipApiServiceRef ref) async {
  return RelationshipApiService();
}

class RelationshipApiService {
  FutureOr<EndpointResponse> blockRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-blockRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> unblockRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-unblockRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> connectRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-connectRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> disconnectRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-disconnectRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> followRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-followRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> unfollowRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-unfollowRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> muteRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-muteRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> unmuteRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-unmuteRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> hideRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-hideRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

  FutureOr<EndpointResponse> unhideRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-unhideRelationship',
      parameters: {
        'target': uid,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<ConversationApiService> conversationApiService(ConversationApiServiceRef ref) async {
  return ConversationApiService();
}

class ConversationApiService {
  // conversation-archiveMembers
  FutureOr<EndpointResponse> archiveMembers({
    required String conversationId,
    required List<String> members,
  }) async {
    return await getHttpsCallableResult(
      name: 'conversation-archiveMembers',
      parameters: {
        'channelId': conversationId,
        'members': members,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<GuidanceApiService> guidanceApiService(GuidanceApiServiceRef ref) async {
  return GuidanceApiService();
}

class GuidanceApiService {
  FutureOr<EndpointResponse> getDirectoryEntryWindow({
    String cursor = '',
  }) async {
    return await getHttpsCallableResult(
      name: 'guidance-getGuidanceDirectoryEntries',
      pagination: Pagination(
        cursor: cursor,
      ),
    );
  }
}
