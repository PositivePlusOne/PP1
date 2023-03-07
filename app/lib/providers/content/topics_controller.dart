// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/services/third_party.dart';
import '../../dtos/database/content/topic.dart';

part 'topics_controller.freezed.dart';
part 'topics_controller.g.dart';

@freezed
class TopicsControllerState with _$TopicsControllerState {
  const factory TopicsControllerState({
    @Default([]) List<Topic> topics,
  }) = _TopicsControllerState;

  factory TopicsControllerState.initialState() => const TopicsControllerState();
}

@Riverpod(keepAlive: true)
class TopicsController extends _$TopicsController {
  @override
  TopicsControllerState build() {
    return TopicsControllerState.initialState();
  }

  Future<void> updateTopics() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    logger.d('updateTopics()');
    if (firebaseAuth.currentUser == null) {
      logger.d('updateTopics() - user is not logged in');
      return;
    }

    if (state.topics.isNotEmpty) {
      logger.d('updateTopics() - topics already loaded');
      return;
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getTopics').call();
    final Map<String, dynamic> topicMap = json.decode(result.data) as Map<String, dynamic>;
    final List<Topic> topics = topicMap.keys.map((String key) => Topic.fromJson(topicMap[key])).toList();

    //* Update state
    logger.d('updateTopics() - topics: $topics');
    state = state.copyWith(topics: topics);
  }
}
