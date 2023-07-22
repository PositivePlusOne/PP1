// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';

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

FutureOr<T> getHttpsCallableResult<T>({
  required String name,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
  T Function(EndpointResponse response)? selector,
}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final FirebaseFunctions firebaseFunctions = providerContainer.read(firebaseFunctionsProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

  final String currentUid = firebaseAuth.currentUser?.uid ?? '';
  final String targetUid = profileControllerState.currentProfile?.flMeta?.id ?? '';
  final String selectedUid = targetUid.isNotEmpty ? targetUid : currentUid;

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
    final HttpsCallableResult response = await firebaseFunctions.httpsCallable(name).call(requestPayload);
    final EndpointResponse responsePayload = EndpointResponse.fromJson(json.decodeSafe(response.data));

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

  FutureOr<EndpointResponse> getFeedWindow(String feedID, String slugID, {String cursor = ''}) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'stream-getFeedWindow',
      parameters: {
        'feed': feedID,
        'options': {
          'slug': slugID,
          'windowLastActivityId': cursor,
        },
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<ActivityApiService> activityApiService(ActivityApiServiceRef ref) async {
  return ActivityApiService();
}

class ActivityApiService {
  FutureOr<Map<String, Object?>> getActivity({
    required String entryId,
  }) async {
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'activities-getActivity',
      selector: (response) => (response.data['activities'] as Map<String, Object?>)[entryId] as Map<String, Object?>,
      parameters: {
        'entryId': entryId,
      },
    );
  }

  FutureOr<Map<String, Object?>> postActivity({
    required String content,
    List<String> tags = const [],
    List<Media> media = const [],
  }) async {
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'activities-postActivity',
      selector: (response) => (response.data['activities'] as Iterable).first,
      parameters: {
        'content': content,
        'tags': tags,
        'media': media.map((e) => e.toJson()).toList(),
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
  FutureOr<EndpointResponse> getRelationship({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'relationship-getRelationship',
      parameters: {
        'target': uid,
      },
    );
  }

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
FutureOr<SearchApiService> searchApiService(SearchApiServiceRef ref) async {
  return SearchApiService();
}

class SearchApiService {
  FutureOr<List<Map<String, Object?>>> search({
    required String query,
    required String index,
    Pagination? pagination,
  }) async {
    final requestPayload = buildRequestPayload(name: 'search-search', pagination: pagination, parameters: {
      'query': query,
      'index': index,
    });

    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final String cacheKey = json.encode(requestPayload);

    final cachedResponse = cacheController.getFromCache(cacheKey);
    if (cachedResponse != null) {
      logger.d('[SearchApiService] Found cached response for $cacheKey');
      return cachedResponse;
    }

    final response = await getHttpsCallableResult(
      name: 'search-search',
      pagination: pagination,
      selector: (response) => response.data[index] as List<dynamic>,
      parameters: {
        'query': query,
        'index': index,
      },
    );

    final List<Map<String, Object?>> responsePayload = response.map((e) => json.decodeSafe(e)).toList();

    logger.d('[SearchApiService] Adding response to cache for $cacheKey');
    cacheController.addToCache(cacheKey, responsePayload);

    return responsePayload;
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
