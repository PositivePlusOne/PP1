// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
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
}
