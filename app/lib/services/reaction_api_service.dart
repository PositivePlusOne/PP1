// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/mentions.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'reaction_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<ReactionApiService> reactionApiService(ReactionApiServiceRef ref) async {
  return ReactionApiService();
}

class ReactionApiService {
  FutureOr<EndpointResponse> sharePostToConversations({
    required String activityId,
    required List<String> targets,
    required String title,
    required String description,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-shareActivityToConversations',
      parameters: {
        'activityId': activityId,
        'targets': targets,
        'title': title,
        'description': description,
      },
    );
  }

  FutureOr<Reaction> getReaction({
    required String reactionId,
  }) async {
    return await getHttpsCallableResult<Reaction>(
      name: 'reaction-getReaction',
      selector: (response) => Reaction.fromJson(json.decodeSafe(response.data)),
      parameters: {
        'reactionId': reactionId,
      },
    );
  }

  FutureOr<Reaction> postReaction({
    required String activityId,
    required String kind,
    List<Mention> mentions = const [],
    String text = '',
  }) async {
    return await getHttpsCallableResult<Reaction>(
      name: 'reaction-postReaction',
      selector: (response) => Reaction.fromJson(json.decodeSafe((response.data['reactions'] as Iterable).first)),
      parameters: {
        'activityId': activityId,
        'kind': kind,
        'text': text,
        'mentions': mentions.map((e) => e.toJson()).toList(),
      },
    );
  }

  FutureOr<EndpointResponse> updateReaction({
    required String reactionId,
    required String text,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-updateReaction',
      parameters: {
        'reactionId': reactionId,
        'text': text,
      },
    );
  }

  FutureOr<EndpointResponse> deleteReaction({
    required String reactionId,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-deleteReaction',
      parameters: {
        'reactionId': reactionId,
      },
    );
  }

  FutureOr<EndpointResponse> listReactionsForActivity({
    required String activityId,
    String kind = 'comment',
    String cursor = '',
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-listReactionsForActivity',
      pagination: Pagination(cursor: cursor),
      parameters: {
        'activityId': activityId,
        'kind': kind,
      },
    );
  }
}
