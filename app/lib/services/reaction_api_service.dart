// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
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
  FutureOr<EndpointResponse> sharePostToFeed({
    required String activityId,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-shareActivityToFeed',
      parameters: {
        'activityId': activityId,
      },
    );
  }

  FutureOr<EndpointResponse> sharePostToConversations({
    required String activityId,
    required List<String> targets,
    required String title,
    required String description,
    String? feed,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-shareActivityToConversations',
      parameters: {
        'activityId': activityId,
        'targets': targets,
        'feed': feed,
        'title': title,
        'description': description,
      },
    );
  }

  FutureOr<Reaction> postReaction({
    required String activityId,
    required String origin,
    required String kind,
    String targetUid = '',
    String text = '',
  }) async {
    return await getHttpsCallableResult<Reaction>(
      name: 'reaction-postReaction',
      targetUid: targetUid,
      selector: (response) => Reaction.fromJson(json.decodeSafe((response.data['reactions'] as Iterable).first)),
      parameters: {
        'activityId': activityId,
        'origin': origin,
        'kind': kind,
        'text': text,
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
