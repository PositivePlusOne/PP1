import 'dart:convert';

import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

FutureOr<Map<String, Object?>> getHttpsCallableResult({
  required String name,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
}) async {
  final FirebaseFunctions firebaseFunctions = providerContainer.read(firebaseFunctionsProvider);
  final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

  final response = await firebaseFunctions.httpsCallable(name).call(<String, dynamic>{
    'sender': profileControllerState.currentProfileId,
    'cursor': pagination?.cursor,
    'limit': pagination?.limit,
    'data': {
      ...parameters,
    }
  });

  final Map<String, Object?> payload = json.decodeSafe(response.data);
  providerContainer.cacheResponseData(payload);

  return payload;
}

@Riverpod(keepAlive: true)
FutureOr<SystemApiService> systemApiService(SystemApiServiceRef ref) async {
  return SystemApiService();
}

class SystemApiService {
  FutureOr<Map<String, Object?>> getSystemConfiguration() async {
    return await getHttpsCallableResult(name: 'system-getSystemConfiguration');
  }

  FutureOr<String> getStreamToken() async {
    final Map<String, Object?> response = await getHttpsCallableResult(name: 'system-getStreamToken');
    return response['token'] as String;
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
    return await getHttpsCallableResult(name: 'activities-getActivity', parameters: {
      'entryId': entryId,
    });
  }
}

@Riverpod(keepAlive: true)
FutureOr<ProfileApiService> profileApiService(ProfileApiServiceRef ref) async {
  return ProfileApiService();
}

class ProfileApiService {
  FutureOr<Map<String, Object?>> updateFcmToken({
    required String fcmToken,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateFcmToken', parameters: {
      'fcmToken': fcmToken,
    });
  }

  FutureOr<Map<String, Object?>> updateEmailAddress({
    required String emailAddress,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateEmailAddress', parameters: {
      'emailAddress': emailAddress,
    });
  }

  FutureOr<Map<String, Object?>> updatePhoneNumber({
    required String phoneNumber,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updatePhoneNumber', parameters: {
      'phoneNumber': phoneNumber,
    });
  }

  FutureOr<Map<String, Object?>> updateName({
    required String name,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateName', parameters: {
      'name': name,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateDisplayName({
    required String displayName,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateDisplayName', parameters: {
      'displayName': displayName,
    });
  }

  FutureOr<Map<String, Object?>> updateBirthday({
    required String birthday,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateBirthday', parameters: {
      'birthday': birthday,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateInterests({
    required List<String> interests,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateInterests', parameters: {
      'interests': interests,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateHivStatus({
    required String hivStatus,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateHivStatus', parameters: {
      'status': hivStatus,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateGenders({
    required List<String> genders,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateHivStatus', parameters: {
      'genders': genders,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updatePlace({
    required String description,
    required String placeId,
    required double latitude,
    required double longitude,
    Set<String> visibilityFlags = const {},
  }) async {
    return await getHttpsCallableResult(name: 'profile-updatePlace', parameters: {
      'description': description,
      'placeId': placeId,
      'latitude': latitude,
      'longitude': longitude,
      'visibilityFlags': visibilityFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateReferenceImage({
    required String base64String,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateReferenceImage', parameters: {
      'referenceImage': base64String,
    });
  }

  FutureOr<Map<String, Object?>> updateProfileImage({
    required String base64String,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateProfileImage', parameters: {
      'profileImage': base64String,
    });
  }

  FutureOr<Map<String, Object?>> updateBiography({
    required String biography,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateBiography', parameters: {
      'biography': biography,
    });
  }

  FutureOr<Map<String, Object?>> updateAccentColor({
    required String accentColor,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateAccentColor', parameters: {
      'accentColor': accentColor,
    });
  }

  FutureOr<Map<String, Object?>> updateFeatureFlags({
    required Set<String> featureFlags,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateFeatureFlags', parameters: {
      'featureFlags': featureFlags.toList(),
    });
  }

  FutureOr<Map<String, Object?>> updateVisibilityFlags({
    required Set<String> visibilityFlags,
  }) async {
    return await getHttpsCallableResult(name: 'profile-updateVisibilityFlags', parameters: {
      'visibilityFlags': visibilityFlags.toList(),
    });
  }
}
