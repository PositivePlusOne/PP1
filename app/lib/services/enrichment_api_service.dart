// Dart imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'enrichment_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<EnrichmentApiService> enrichmentApiService(EnrichmentApiServiceRef ref) async {
  return EnrichmentApiService();
}

class EnrichmentApiService {
  FutureOr<EndpointResponse> followTag({
    required List<String> tags,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'enrichment-followTags',
      parameters: {
        'tags': tags,
      },
    );
  }

  FutureOr<EndpointResponse> getPromotionWindow({
    required String cursor,
    int limit = 30,
  }) async {
    return await getHttpsCallableResult(
      name: 'enrichment-getPromotionWindow',
      pagination: Pagination(
        cursor: cursor,
        limit: limit,
      ),
    );
  }
}
