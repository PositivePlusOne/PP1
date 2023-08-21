// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/pagination/pagination.dart';
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
    required String feed,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'post-shareActivityToFeed',
      parameters: {
        'activityId': activityId,
        'feed': feed,
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

  FutureOr<EndpointResponse> postReaction({
    required String activityId,
    required String reactionType,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-postReaction',
      parameters: {
        'activityId': activityId,
        'reactionType': reactionType,
      },
    );
  }

  FutureOr<EndpointResponse> updateReaction({
    required String reactionId,
    required String reactionType,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-updateReaction',
      parameters: {
        'reactionId': reactionId,
        'reactionType': reactionType,
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
    String cursor = '',
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'reaction-listReactionsForActivity',
      pagination: Pagination(cursor: cursor),
      parameters: {
        'activityId': activityId,
      },
    );
  }
}
