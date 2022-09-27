// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zephyr_rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ZephyrRestClient implements ZephyrRestClient {
  _ZephyrRestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.zephyrscale.smartbear.com/v2';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ZephyrPaginatedResults> getTestCycles(projectKey, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'projectKey': projectKey};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ZephyrPaginatedResults>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/testcycles',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ZephyrPaginatedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ZephyrPaginatedResults> getTestCases(projectKey, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'projectKey': projectKey};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ZephyrPaginatedResults>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/testcases',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ZephyrPaginatedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> publishTestExecution(execution, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(execution.toJson());
    final _result = await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/testexecutions',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
