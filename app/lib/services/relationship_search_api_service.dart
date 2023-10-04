// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'relationship_search_api_service.g.dart';

@Riverpod(keepAlive: true)
RelationshipSearchApiService relationshipSearchApiService(RelationshipSearchApiServiceRef ref) {
  return RelationshipSearchApiService();
}

class RelationshipSearchApiService {
  static const int kDefaultLimit = 50;

  FutureOr<EndpointResponse> listConnectedRelationships({
    String cursor = '',
    int limit = kDefaultLimit,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'relationship-listConnectedRelationships',
      pagination: Pagination(
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  FutureOr<EndpointResponse> listFollowedRelationships({
    String cursor = '',
    int limit = kDefaultLimit,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'relationship-listFollowRelationships',
      pagination: Pagination(
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  FutureOr<EndpointResponse> listFollowingRelationships({
    String cursor = '',
    int limit = kDefaultLimit,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'relationship-listFollowingRelationships',
      pagination: Pagination(
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  FutureOr<EndpointResponse> listBlockedRelationships({
    String cursor = '',
    int limit = kDefaultLimit,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'relationship-listBlockedRelationships',
      pagination: Pagination(
        cursor: cursor,
        limit: limit,
      ),
    );
  }
}
