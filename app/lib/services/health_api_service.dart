// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'health_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<HealthApiService> healthApiService(HealthApiServiceRef ref) async {
  return HealthApiService();
}

class HealthApiService {
  FutureOr<EndpointResponse> updateLocalCache({
    required List<String> requestIds,
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'health-updateLocalCache',
      parameters: {
        'requestIds': requestIds,
      },
    );
  }
}
