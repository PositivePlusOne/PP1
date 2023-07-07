// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

part 'api.g.dart';

FutureOr<Map<String, Object?>> getHttpsCallableResult({
  required String name,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
  Function(Map<String, Object?> data)? selector,
}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final FirebaseFunctions firebaseFunctions = providerContainer.read(firebaseFunctionsProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

  final String currentUid = firebaseAuth.currentUser?.uid ?? '';
  final String targetUid = profileControllerState.currentProfile?.flMeta?.id ?? '';

  logger.d('getHttpsCallableResult: $name, $pagination, $parameters');
  if (currentUid.isNotEmpty && currentUid != targetUid) {
    logger.i('getHttpsCallableResult: Target uid is not current uid');
    logger.i('getHttpsCallableResult: $currentUid -> $targetUid');
  }

  final response = await firebaseFunctions.httpsCallable(name).call(<String, dynamic>{
    'sender': profileControllerState.currentProfile?.flMeta?.id,
    'cursor': pagination?.cursor,
    'limit': pagination?.limit,
    'data': {
      ...parameters,
    }
  });

  final Map<String, Object?> payload = json.decodeSafe(response.data);
  providerContainer.cacheResponseData(payload);

  if (selector == null) {
    return response.data;
  }

  return selector(payload);
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
    return await getHttpsCallableResult(
      name: 'activities-getActivity',
      selector: (Map<String, Object?> data) => (data['activities'] as Map<String, Object?>)[entryId],
      parameters: {
        'entryId': entryId,
      },
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<ProfileApiService> profileApiService(ProfileApiServiceRef ref) async {
  return ProfileApiService();
}

class ProfileApiService {
  FutureOr<Map<String, Object?>> getProfile({
    required String uid,
  }) async {
    return await getHttpsCallableResult(
      name: 'profile-getProfile',
      selector: (Map<String, Object?> data) => (data['users'] as Map<String, Object?>)[uid],
      parameters: {
        'uid': uid,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateFcmToken({
    required String fcmToken,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateFcmToken',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'fcmToken': fcmToken,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateEmailAddress({
    required String emailAddress,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateEmailAddress',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'emailAddress': emailAddress,
      },
    );
  }

  FutureOr<Map<String, Object?>> updatePhoneNumber({
    required String phoneNumber,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updatePhoneNumber',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateName',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateDisplayName',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateBirthday',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateInterests',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateHivStatus',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    return await getHttpsCallableResult(
      name: 'profile-updateHivStatus',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
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
    Set<String> visibilityFlags = const {},
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updatePlace',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
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
    return await getHttpsCallableResult(
      name: 'profile-updateReferenceImage',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'referenceImage': base64String,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateProfileImage({
    required String base64String,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateProfileImage',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'profileImage': base64String,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateBiography({
    required String biography,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateBiography',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'biography': biography,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateAccentColor({
    required String accentColor,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateAccentColor',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'accentColor': accentColor,
      },
    );
  }

  FutureOr<Map<String, Object?>> updateFeatureFlags({
    required Set<String> featureFlags,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateFeatureFlags',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'featureFlags': featureFlags.toList(),
      },
    );
  }

  FutureOr<Map<String, Object?>> updateVisibilityFlags({
    required Set<String> visibilityFlags,
  }) async {
    final String currentUid = providerContainer.read(profileControllerProvider.notifier).currentProfileId ?? '';
    return await getHttpsCallableResult(
      name: 'profile-updateVisibilityFlags',
      selector: (data) => (data['users'] as Map<String, Object?>)[currentUid],
      parameters: {
        'visibilityFlags': visibilityFlags.toList(),
      },
    );
  }
}
