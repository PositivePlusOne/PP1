// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/services/third_party.dart';
import '../../dtos/database/content/topic.dart';

part 'interests_controller.freezed.dart';
part 'interests_controller.g.dart';

@freezed
class InterestsControllerState with _$InterestsControllerState {
  const factory InterestsControllerState({
    @Default({}) Map<String, String> interests,
  }) = _InterestsControllerState;

  factory InterestsControllerState.initialState() => const InterestsControllerState();
}

@Riverpod(keepAlive: true)
class InterestsController extends _$InterestsController {
  @override
  InterestsControllerState build() {
    return InterestsControllerState.initialState();
  }

  Future<void> updateInterests() async {
    final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.interests.isNotEmpty) {
      logger.d('updateInterests() - interests already loaded');
      return;
    }

    String locale = profileControllerState.userProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateInterests() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getInterests').call({
      'locale': locale,
    });

    //* Update state
    final Map<String, dynamic> rawInterests = json.decode(result.data);
    final Map<String, String> interests = rawInterests.map((String key, dynamic value) {
      return MapEntry<String, String>(key, value as String);
    });

    logger.d('updateInterests() - updating interests: $interests');
    state = state.copyWith(interests: interests);
  }
}
