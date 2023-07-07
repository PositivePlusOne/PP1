// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

// Project imports:

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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.interests.isNotEmpty) {
      logger.d('updateInterests() - interests already loaded');
      return;
    }

    String locale = profileController.state.currentProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateInterests() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getInterests').call({
      'locale': locale,
    });

    final Map<String, dynamic> rawInterests = json.decode(result.data);
    onInterestsUpdated(rawInterests);
  }

  void onInterestsUpdated(Map<dynamic, dynamic> result) {
    final Logger logger = ref.read(loggerProvider);
    final Map<String, String> interests = result.map((dynamic key, dynamic value) {
      return MapEntry<String, String>(key, value as String);
    });

    logger.d('updateInterests() - updating interests: $interests');
    state = state.copyWith(interests: interests);
  }

  Iterable<String> localiseInterests(Iterable<String> keys) {
    final List<String> returnList = [];
    for (var key in keys) {
      if (state.interests.containsKey(key)) {
        returnList.add(state.interests[key]!);
      }
    }
    return returnList;
  }

  String localiseInterestsAsSingleString(Iterable<String> keys) {
    final Iterable<String> stringList = localiseInterests(keys);

    return stringList.join(', ');
  }
}
