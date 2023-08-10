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
