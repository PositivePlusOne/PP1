// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'comment_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<CommentApiService> commentApiService(CommentApiServiceRef ref) async {
  return CommentApiService();
}

class CommentApiService {
  FutureOr<EndpointResponse> postComment({
    required String activityId,
    required String content,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'comment-postComment',
      parameters: {
        'activityId': activityId,
        'content': content,
      },
    );
  }

  FutureOr<EndpointResponse> updateComment({
    required String commentId,
    required String content,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'comment-updateComment',
      parameters: {
        'commentId': commentId,
        'content': content,
      },
    );
  }

  FutureOr<EndpointResponse> deleteComment({
    required String commentId,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'comment-deleteComment',
      parameters: {
        'commentId': commentId,
      },
    );
  }

  FutureOr<EndpointResponse> listCommentsForActivity({
    required String activityId,
    String cursor = '',
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'comment-listCommentsForActivity',
      pagination: Pagination(cursor: cursor),
      parameters: {
        'activityId': activityId,
      },
    );
  }
}
