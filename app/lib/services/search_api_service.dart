// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/services/third_party.dart';

part 'search_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<SearchApiService> searchApiService(SearchApiServiceRef ref) async {
  return SearchApiService();
}

class SearchResult<T> {
  SearchResult({required this.results, required this.cursor});

  final List<T> results;
  final String cursor;
}

class SearchApiService {
  Future<SearchResult<T>> search<T>({
    required String query,
    required String index,
    required T Function(Map<String, dynamic> json) fromJson,
    List<String> filters = const [],
    Pagination? pagination,
  }) async {
    final requestPayload = buildRequestPayload(name: 'search-search', pagination: pagination, parameters: {
      'query': query,
      'index': index,
      'filters': filters,
    });

    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String cacheKey = json.encode(requestPayload);

    final SearchResult<T>? cachedResponse = cacheController.get(cacheKey);
    if (cachedResponse != null && cachedResponse.results.isNotEmpty) {
      logger.d('[SearchApiService] Found cached response for $cacheKey');
      return cachedResponse;
    }

    final EndpointResponse response = await getHttpsCallableResult(
      name: 'search-search',
      pagination: pagination,
      parameters: {
        'query': query,
        'index': index,
        'filters': filters,
      },
    );

    if (!response.data.containsKey(index)) {
      logger.e('[SearchApiService] Response does not contain key $index');
      return SearchResult<T>(results: [], cursor: '');
    }

    final List searchData = response.data[index] as List<dynamic>;
    final List<T> responseData = [];

    for (final result in searchData) {
      try {
        final T obj = fromJson(result as Map<String, dynamic>);
        responseData.add(obj);
      } catch (e) {
        logger.e('[SearchApiService] Failed to deserialize result as $T: $e');
      }
    }

    if (responseData.isEmpty) {
      logger.d('[SearchApiService] No results found for $query');
      return SearchResult<T>(results: [], cursor: '');
    }

    logger.d('[SearchApiService] Adding response to cache for $cacheKey');
    final SearchResult<T> result = SearchResult<T>(results: responseData, cursor: response.cursor ?? '');
    cacheController.add(key: cacheKey, value: result);

    return result;
  }
}
