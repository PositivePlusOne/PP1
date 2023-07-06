import 'dart:convert';

import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/riverpod_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@riverpod
FutureOr<Map<String, Object?>> getHttpsCallableResult(
  GetHttpsCallableResultRef ref, {
  required String name,
  Pagination? pagination,
  Map<String, dynamic> parameters = const {},
}) async {
  final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);
  final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final HttpsCallable callable = firebaseFunctions.httpsCallable(name);

  final response = await callable.call(<String, dynamic>{
    'sender': profileControllerState.currentProfileId,
    'cursor': pagination?.cursor,
    'limit': pagination?.limit,
    'data': {
      ...parameters,
    }
  });

  final Map<String, Object?> payload = json.decodeSafe(response.data);
  ref.cacheResponseData(payload);

  return payload;
}

// System
@riverpod
FutureOr<Map<String, Object?>> getSystemConfiguration(GetSystemConfigurationRef ref) async {
  return await getHttpsCallableResult(ref, name: 'system-getSystemConfiguration');
}

// Actitivies
@riverpod
FutureOr<Map<String, Object?>> getActivity(
  GetActivityRef ref, {
  required String entryId,
}) async {
  return await getHttpsCallableResult(ref, name: 'activities-getActivity', parameters: {
    'entryId': entryId,
  });
}

// Profile
@riverpod
FutureOr<Map<String, Object?>> updateFcmToken(
  UpdateFcmTokenRef ref, {
  required String fcmToken,
}) async {
  return await getHttpsCallableResult(ref, name: 'profile-updateFcmToken', parameters: {
    'fcmToken': fcmToken,
  });
}

@riverpod
FutureOr<Map<String, Object?>> updateEmailAddress(
  UpdateEmailAddressRef ref, {
  required String emailAddress,
}) async {
  return await getHttpsCallableResult(ref, name: 'profile-updateEmailAddress', parameters: {
    'emailAddress': emailAddress,
  });
}
