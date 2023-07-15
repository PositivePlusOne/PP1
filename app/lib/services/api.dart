// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
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
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
}) {
  final Map<String, dynamic> requestPayload = <String, dynamic>{
    'name': name,
    'sender': providerContainer.read(profileControllerProvider.notifier).state.currentProfile?.flMeta?.id,
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
  T Function(Map<String, Object?> data)? selector,
}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final FirebaseFunctions firebaseFunctions = providerContainer.read(firebaseFunctionsProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

  final String currentUid = firebaseAuth.currentUser?.uid ?? '';
  final String targetUid = profileControllerState.currentProfile?.flMeta?.id ?? '';

  logger.d('getHttpsCallableResult: $name, $pagination, $parameters');
  if (currentUid.isNotEmpty && targetUid.isNotEmpty && currentUid != targetUid) {
    logger.i('getHttpsCallableResult: Target uid is not current uid');
    logger.i('getHttpsCallableResult: $currentUid -> $targetUid');
  }

  final requestPayload = buildRequestPayload(
    name: name,
    pagination: pagination,
    parameters: parameters,
  );

  final HttpsCallableResult response = await firebaseFunctions.httpsCallable(name).call(requestPayload);
  final Map<String, Object?> responsePayload = json.decodeSafe(response.data);
  providerContainer.cacheResponseData(responsePayload);

  if (selector == null) {
    return response.data;
  }

  return selector(responsePayload);
}

@Riverpod(keepAlive: true)
FutureOr<SystemApiService> systemApiService(SystemApiServiceRef ref) async {
  return SystemApiService();
}

class SystemApiService {
  FutureOr<Map<String, Object?>> getSystemConfiguration() async {
    return await getHttpsCallableResult(
      name: 'system-getSystemConfiguration',
    );
  }

  FutureOr<String> getStreamToken() async {
    return await getHttpsCallableResult<String>(
      name: 'system-getStreamToken',
      selector: (data) => data['token'].toString(),
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
      selector: (Map<String, Object?> data) => (data['activities'] as Map<String, Object?>)[entryId] as Map<String, Object?>,
      parameters: {
        'entryId': entryId,
      },
    );
  }

  FutureOr<void> postActivity({
    required Activity activity,
  }) async {
    await getHttpsCallableResult<Map<String, Object?>>(
      name: 'activities-postActivity',
      parameters: {
        'activity': activity.toJson(),
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
      selector: (data) => (data['users'] as List).map((e) => json.decodeSafe(e)).toList(),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == uid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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

  FutureOr<Map<String, Object?>> updateReferenceImage({
    required String base64String,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateReferenceImage',
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'referenceImage': base64String,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateProfileImage({
    required String base64String,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateProfileImage',
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'profileImage': base64String,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateBiography({
    required String biography,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateBiography',
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
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
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['fl_id'] == currentUid)),
      parameters: {
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateMedia({
    required List<Media> media,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    final List<Map<String, Object?>> mediaList = media.map((e) => e.toJson()).toList();
    return await getHttpsCallableResult<Map<String, Object?>>(
      name: 'profile-updateMedia',
      selector: (data) => json.decodeSafe((data['users'] as List).firstWhere((element) => element['_fl_meta_']['id'] == currentUid)),
      parameters: {
        'media': mediaList,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<SearchApiService> searchApiService(SearchApiServiceRef ref) async {
  return SearchApiService();
}

class SearchApiService {
  FutureOr<Map<String, Object?>> search({
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
      selector: (data) => json.decodeSafe(data[index] as List),
      pagination: pagination,
      parameters: {
        'query': query,
        'index': index,
      },
    );

    logger.d('[SearchApiService] Adding response to cache for $cacheKey');
    cacheController.addToCache(cacheKey, response);
    return response;
  }

  FutureOr<List<Tag>> searchTags({
    required String query,
    Pagination? pagination,
  }) async {
    return await getHttpsCallableResult(
      name: 'search-search',
      selector: (data) => (data['tags'] as List).map((e) => Tag.fromJson(json.decodeSafe(e))).toList(),
      pagination: pagination,
      parameters: {
        'index': 'tags',
        'query': query,
      },
    );
  }
}
