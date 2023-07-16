import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_response.freezed.dart';
part 'endpoint_response.g.dart';

@freezed
class EndpointResponse with _$EndpointResponse {
  const factory EndpointResponse({
    @Default({}) Map<String, Object?> data,
    String? cursor,
    @Default(10) int limit,
  }) = _EndpointResponse;

  factory EndpointResponse.fromJson(Map<String, dynamic> json) => _$EndpointResponseFromJson(json);
}
