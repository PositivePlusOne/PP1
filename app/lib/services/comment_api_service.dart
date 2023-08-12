// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/comments.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/json_extensions.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'comment_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<CommentApiService> commentApiService(CommentApiServiceRef ref) async {
  return CommentApiService();
}

class CommentApiService {
  FutureOr<Comment> postComment({
    required String activityId,
    required String content,
  }) async {
    return await getHttpsCallableResult<Comment>(
      name: 'comment-postComment',
      selector: (response) => Comment.fromJson(json.decodeSafe((response.data['comments'] as Iterable).first)),
      parameters: {
        'activityId': activityId,
        'content': content,
      },
    );
  }

  FutureOr<Comment> updateComment({
    required String commentId,
    required String content,
  }) async {
    return await getHttpsCallableResult<Comment>(
      name: 'comment-updateComment',
      selector: (response) => Comment.fromJson(json.decodeSafe((response.data['comments'] as Iterable).first)),
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
    required String feedID,
    required String slugID,
    String cursor = '',
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'comment-listCommentsForActivity',
      pagination: Pagination(cursor: cursor),
      parameters: {
        'activityId': activityId,
        'feed': feedID,
        'options': {
          'slug': slugID,
        },
      },
    );
  }
}
