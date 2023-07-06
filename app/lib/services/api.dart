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
}
